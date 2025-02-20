class UserModel {
  final String id;
  final String name;
  final DateTime createdAt;

  const UserModel({
    required this.id,
    required this.name,
    required this.createdAt
  });

  factory UserModel.fromMap(Map<String, dynamic> map) => UserModel(
      id: map['id'] != null ? map['username'] as String : '',
      name: map['username'] != null ? map['username'] as String : '',
      createdAt: DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String())
  );
}