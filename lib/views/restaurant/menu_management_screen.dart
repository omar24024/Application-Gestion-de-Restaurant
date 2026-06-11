import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import '../../l10n/app_localizations.dart';

class MenuManagementScreen extends StatefulWidget {
  const MenuManagementScreen({super.key});
  @override
  State<MenuManagementScreen> createState() => _MenuManagementScreenState();
}

class _MenuManagementScreenState extends State<MenuManagementScreen> {
  final _supabase = Supabase.instance.client;
  List<Map<String, dynamic>> plats = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPlats();
  }

  Future<void> _fetchPlats() async {
    setState(() => isLoading = true);
    final data = await _supabase.from('plats').select().order('id');
    setState(() {
      plats = List<Map<String, dynamic>>.from(data);
      isLoading = false;
    });
  }

  Future<void> _deletePlat(int id) async {
    await _supabase.from('plats').delete().eq('id', id);
    _fetchPlats();
  }

  Future<void> _toggleDisponible(int id, bool current) async {
    await _supabase.from('plats').update({'disponible': !current}).eq('id', id);
    _fetchPlats();
  }

  Future<String?> _uploadImage(Uint8List bytes) async {
    try {
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      await _supabase.storage
          .from('plats-images')
          .uploadBinary(fileName, bytes,
              fileOptions: const FileOptions(contentType: 'image/jpeg'));
      return _supabase.storage.from('plats-images').getPublicUrl(fileName);
    } catch (e) {
      return null;
    }
  }

  void _showForm({Map<String, dynamic>? plat}) {
    final l10n = AppLocalizations.of(context)!;
    final nomCtrl = TextEditingController(text: plat?['nom'] ?? '');
    final descCtrl = TextEditingController(text: plat?['description'] ?? '');
    final prixCtrl = TextEditingController(text: plat?['prix']?.toString() ?? '');
    Uint8List? imageBytes;
    String? imageUrl = plat?['image_url'];
    bool uploading = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 16, right: 16, top: 20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(plat == null ? l10n.addDish : l10n.editDish,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                // Image picker
                GestureDetector(
                  onTap: () async {
                    final picker = ImagePicker();
                    final picked = await picker.pickImage(
                        source: ImageSource.gallery, imageQuality: 70);
                    if (picked != null) {
                      final bytes = await picked.readAsBytes();
                      setModalState(() { imageBytes = bytes; uploading = true; });
                      final url = await _uploadImage(bytes);
                      setModalState(() { imageUrl = url; uploading = false; });
                    }
                  },
                  child: Container(
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.orange, width: 2),
                    ),
                    child: uploading
                        ? const Center(child: CircularProgressIndicator(color: Colors.orange))
                        : imageBytes != null
                            ? Stack(children: [
                                ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.memory(imageBytes!,
                                        width: double.infinity, fit: BoxFit.cover)),
                                Positioned(
                                  top: 8, right: 8,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(
                                        color: Colors.orange, shape: BoxShape.circle),
                                    child: const Icon(Icons.edit, color: Colors.white, size: 16),
                                  ),
                                ),
                              ])
                            : imageUrl != null
                                ? Stack(children: [
                                    ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.network(imageUrl!,
                                            width: double.infinity, fit: BoxFit.cover,
                                            errorBuilder: (_, __, ___) => const Icon(
                                                Icons.add_photo_alternate,
                                                color: Colors.orange, size: 50))),
                                    Positioned(
                                      top: 8, right: 8,
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: const BoxDecoration(
                                            color: Colors.orange, shape: BoxShape.circle),
                                        child: const Icon(Icons.edit, color: Colors.white, size: 16),
                                      ),
                                    ),
                                  ])
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.add_photo_alternate,
                                          color: Colors.orange, size: 50),
                                      const SizedBox(height: 8),
                                      Text(l10n.tapToChooseImage,
                                          style: const TextStyle(color: Colors.orange)),
                                    ],
                                  ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(controller: nomCtrl,
                    decoration: InputDecoration(labelText: l10n.dishName, border: const OutlineInputBorder())),
                const SizedBox(height: 12),
                TextField(controller: descCtrl,
                    decoration: InputDecoration(labelText: l10n.description, border: const OutlineInputBorder())),
                const SizedBox(height: 12),
                TextField(controller: prixCtrl, keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: l10n.priceDA, border: const OutlineInputBorder())),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: const EdgeInsets.symmetric(vertical: 14)),
                    onPressed: uploading ? null : () async {
                      final data = {
                        'nom': nomCtrl.text.trim(),
                        'description': descCtrl.text.trim(),
                        'prix': double.tryParse(prixCtrl.text) ?? 0,
                        'image_url': imageUrl,
                        'disponible': true,
                      };
                      if (plat == null) {
                        await _supabase.from('plats').insert(data);
                      } else {
                        await _supabase.from('plats').update(data).eq('id', plat['id']);
                      }
                      if (context.mounted) Navigator.pop(context);
                      _fetchPlats();
                    },
                    child: Text(plat == null ? l10n.add : l10n.edit,
                        style: const TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.menuManagement),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed: () => _showForm(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : plats.isEmpty
              ? Center(child: Text(l10n.noDishesAddSome))
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: plats.length,
                  itemBuilder: (context, index) {
                    final plat = plats[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        leading: SizedBox(
                          width: 55, height: 55,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: plat['image_url'] != null
                                ? Image.network(
                                    plat['image_url'],
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Container(
                                        color: Colors.orange.shade50,
                                        child: const Icon(Icons.fastfood, color: Colors.orange)),
                                  )
                                : Container(
                                    color: Colors.orange.shade50,
                                    child: const Icon(Icons.fastfood, color: Colors.orange)),
                          ),
                        ),
                        title: Text(plat['nom'],
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('${plat['prix']} DA',
                            style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Switch(
                              value: plat['disponible'] ?? true,
                              activeColor: Colors.green,
                              onChanged: (_) => _toggleDisponible(plat['id'], plat['disponible']),
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => _showForm(plat: plat),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: Text(l10n.deleteQuestion),
                                  content: Text(l10n.deleteConfirm(plat['nom'])),
                                  actions: [
                                    TextButton(onPressed: () => Navigator.pop(context),
                                        child: Text(l10n.cancel)),
                                    TextButton(
                                        onPressed: () { Navigator.pop(context); _deletePlat(plat['id']); },
                                        child: Text(l10n.delete,
                                            style: const TextStyle(color: Colors.red))),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}