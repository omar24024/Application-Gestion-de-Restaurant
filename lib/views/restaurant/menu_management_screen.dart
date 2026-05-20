import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';

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

  void _showForm({Map<String, dynamic>? plat}) {
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
                Text(plat == null ? 'Ajouter un plat' : 'Modifier le plat',
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
                      setModalState(() {
                        imageBytes = bytes;
                        uploading = true;
                      });

                      try {
                        final fileName =
                            '${DateTime.now().millisecondsSinceEpoch}.jpg';
                        await _supabase.storage
                            .from('plats-images')
                            .uploadBinary(fileName, bytes,
                                fileOptions: const FileOptions(
                                    contentType: 'image/jpeg'));
                        final url = _supabase.storage
                            .from('plats-images')
                            .getPublicUrl(fileName);
                        setModalState(() {
                          imageUrl = url;
                          uploading = false;
                        });
                      } catch (e) {
                        setModalState(() => uploading = false);
                      }
                    }
                  },
                  child: Container(
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.orange),
                    ),
                    child: uploading
                        ? const Center(child: CircularProgressIndicator(color: Colors.orange))
                        : imageBytes != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.memory(imageBytes!, fit: BoxFit.cover))
                            : imageUrl != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(imageUrl!, fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) => const Icon(
                                            Icons.add_photo_alternate,
                                            color: Colors.orange, size: 50)))
                                : const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.add_photo_alternate,
                                          color: Colors.orange, size: 50),
                                      SizedBox(height: 8),
                                      Text('Appuyer pour choisir une image',
                                          style: TextStyle(color: Colors.orange)),
                                    ],
                                  ),
                  ),
                ),
                const SizedBox(height: 12),

                TextField(
                    controller: nomCtrl,
                    decoration: const InputDecoration(
                        labelText: 'Nom du plat', border: OutlineInputBorder())),
                const SizedBox(height: 12),
                TextField(
                    controller: descCtrl,
                    decoration: const InputDecoration(
                        labelText: 'Description', border: OutlineInputBorder())),
                const SizedBox(height: 12),
                TextField(
                    controller: prixCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        labelText: 'Prix (DA)', border: OutlineInputBorder())),
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
                    child: Text(plat == null ? 'Ajouter' : 'Modifier',
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion du menu'),
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
              ? const Center(child: Text('Aucun plat — ajoutez-en !'))
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: plats.length,
                  itemBuilder: (context, index) {
                    final plat = plats[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        leading: plat['image_url'] != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(plat['image_url'],
                                    width: 50, height: 50, fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => const CircleAvatar(
                                        backgroundColor: Colors.orange,
                                        child: Icon(Icons.fastfood, color: Colors.white))))
                            : const CircleAvatar(
                                backgroundColor: Colors.orange,
                                child: Icon(Icons.fastfood, color: Colors.white)),
                        title: Text(plat['nom'],
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('${plat['prix']} DA',
                            style: const TextStyle(color: Colors.orange)),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Switch(
                              value: plat['disponible'] ?? true,
                              activeColor: Colors.green,
                              onChanged: (_) =>
                                  _toggleDisponible(plat['id'], plat['disponible']),
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
                                  title: const Text('Supprimer ?'),
                                  content: Text('Supprimer "${plat['nom']}" ?'),
                                  actions: [
                                    TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('Annuler')),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          _deletePlat(plat['id']);
                                        },
                                        child: const Text('Supprimer',
                                            style: TextStyle(color: Colors.red))),
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
