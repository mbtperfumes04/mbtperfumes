class UserFields {
  static const String table = 'users';
  static const String id = 'id';
  static const String name = 'name';
  static const String contactNo = 'contactNo';
  static const String email = 'email';
  static const String birthday = 'birthday';
  static const String bio = 'bio';
  static const String gender = 'gender';
  static const String createdAt = 'createdAt';
  static const String updatedAt = 'updatedAt';
  static const String isVerified = 'isVerified';
  static const String address = 'address';
}

class UserModel {
  final String id;
  final String name;
  final String? contactNo;
  final String? email;
  final DateTime? birthday;
  final String? bio;
  final String? gender;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool? isVerified;
  final String? address;

  const UserModel({
    required this.id,
    required this.name,
    this.contactNo,
    this.email,
    this.birthday,
    this.bio,
    this.gender,
    required this.createdAt,
    this.updatedAt,
    this.isVerified,
    this.address,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) => UserModel(
    id: map[UserFields.id] ?? '',
    name: map[UserFields.name] ?? '',
    contactNo: map[UserFields.contactNo],
    email: map[UserFields.email],
    birthday: map[UserFields.birthday] != null
        ? DateTime.tryParse(map[UserFields.birthday])
        : null,
    bio: map[UserFields.bio],
    gender: map[UserFields.gender],
    createdAt: DateTime.tryParse(map[UserFields.createdAt] ?? '') ??
        DateTime.now(),
    updatedAt: map[UserFields.updatedAt] != null
        ? DateTime.tryParse(map[UserFields.updatedAt])
        : null,
    isVerified: map[UserFields.isVerified] == 1 ||
        map[UserFields.isVerified] == true,
    address: map[UserFields.address],
  );

  Map<String, dynamic> toMap() => {
    UserFields.id: id,
    UserFields.name: name,
    UserFields.contactNo: contactNo,
    UserFields.email: email,
    UserFields.birthday: birthday?.toIso8601String(),
    UserFields.bio: bio,
    UserFields.gender: gender,
    UserFields.createdAt: createdAt.toIso8601String(),
    UserFields.updatedAt: updatedAt?.toIso8601String(),
    UserFields.isVerified: isVerified == true ? 1 : 0,
    UserFields.address: address,
  };

  UserModel copyWith({
    String? id,
    String? name,
    String? contactNo,
    String? email,
    DateTime? birthday,
    String? bio,
    String? gender,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isVerified,
    String? address,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      contactNo: contactNo ?? this.contactNo,
      email: email ?? this.email,
      birthday: birthday ?? this.birthday,
      bio: bio ?? this.bio,
      gender: gender ?? this.gender,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isVerified: isVerified ?? this.isVerified,
      address: address ?? this.address,
    );
  }

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, contactNo: $contactNo, email: $email, birthday: $birthday, bio: $bio, gender: $gender, createdAt: $createdAt, updatedAt: $updatedAt, isVerified: $isVerified, address: $address)';
  }
}
