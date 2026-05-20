class UserModel {
  final String id;
  final String fullName;
  final String role;
  final String email;

  UserModel({
    required this.id,
    required this.fullName,
    required this.role,
    required this.email,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      fullName: map['full_name'] ?? '',
      role: map['role'] ?? 'client',
      email: map['email'] ?? '',
    );
  }

  factory UserModel.fromSupabaseUser(dynamic user) {
    return UserModel(
      id: user.id,
      fullName: user.userMetadata['full_name'] ?? '',
      role: user.userMetadata['role'] ?? 'client',
      email: user.email ?? '',
    );
  }
}