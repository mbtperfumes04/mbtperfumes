class ProfileFields {
  static const String table = 'users';
  static const String id = 'id';
  static const String email = 'email';
  static const String username = 'username';
  static const String birthday = 'birthday';
  static const String bio = 'bio';
  static const String gender = 'gender';
  static const String firstName = 'first_name';
  static const String lastName = 'last_name';
  static const String avatarUrl = 'avatar_url';
  static const String role = 'role';
  static const String country = 'country';
  static const String region = 'region';
  static const String province = 'province';
  static const String cityMunicipal = 'city_municipal';
  static const String barangay = 'barangay';
  static const String street = 'street';
  static const String postalCode = 'postal_code';
  static const String referralCode = 'referral_code';
  static const String lastLogin = 'last_login';
  static const String createdAt = 'created_at';
  static const String updatedAt = 'updated_at';
}

class ProfileModel {
  final String? id;
  final String? email;
  final String? username;
  final DateTime? birthday;
  final String? bio;
  final String? gender;
  final String? firstName;
  final String? lastName;
  final String? avatarUrl;
  final String? role;
  final String? country;
  final String? region;
  final String? province;
  final String? cityMunicipal;
  final String? barangay;
  final String? street;
  final String? postalCode;
  final String? referralCode;
  final DateTime? lastLogin;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ProfileModel({
    this.id,
    this.email,
    this.username,
    this.birthday,
    this.bio,
    this.gender,
    this.firstName,
    this.lastName,
    this.avatarUrl,
    this.role,
    this.country,
    this.region,
    this.province,
    this.cityMunicipal,
    this.barangay,
    this.street,
    this.postalCode,
    this.referralCode,
    this.lastLogin,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProfileModel.fromMap(Map<String, dynamic> map) => ProfileModel(
    id: map[ProfileFields.id],
    email: map[ProfileFields.email],
    username: map[ProfileFields.username],
    birthday: map[ProfileFields.birthday] != null
        ? DateTime.tryParse(map[ProfileFields.birthday])
        : null,
    bio: map[ProfileFields.bio],
    gender: map[ProfileFields.gender],
    firstName: map[ProfileFields.firstName],
    lastName: map[ProfileFields.lastName],
    avatarUrl: map[ProfileFields.avatarUrl],
    role: map[ProfileFields.role],
    country: map[ProfileFields.country],
    region: map[ProfileFields.region],
    province: map[ProfileFields.province],
    cityMunicipal: map[ProfileFields.cityMunicipal],
    barangay: map[ProfileFields.barangay],
    street: map[ProfileFields.street],
    postalCode: map[ProfileFields.postalCode],
    referralCode: map[ProfileFields.referralCode],
    lastLogin: map[ProfileFields.lastLogin] != null
        ? DateTime.tryParse(map[ProfileFields.lastLogin])
        : null,
    createdAt: DateTime.tryParse(map[ProfileFields.createdAt] ?? '') ??
        DateTime.now(),
    updatedAt: DateTime.tryParse(map[ProfileFields.updatedAt] ?? '') ??
        DateTime.now(),
  );

  Map<String, dynamic> toMap() => {
    ProfileFields.id: id,
    ProfileFields.email: email,
    ProfileFields.username: username,
    ProfileFields.birthday: birthday?.toIso8601String(),
    ProfileFields.bio: bio,
    ProfileFields.gender: gender,
    ProfileFields.firstName: firstName,
    ProfileFields.lastName: lastName,
    ProfileFields.avatarUrl: avatarUrl,
    ProfileFields.role: role,
    ProfileFields.country: country,
    ProfileFields.region: region,
    ProfileFields.province: province,
    ProfileFields.cityMunicipal: cityMunicipal,
    ProfileFields.barangay: barangay,
    ProfileFields.street: street,
    ProfileFields.postalCode: postalCode,
    ProfileFields.referralCode: referralCode,
    ProfileFields.lastLogin: lastLogin?.toIso8601String(),
    ProfileFields.createdAt: createdAt.toIso8601String(),
    ProfileFields.updatedAt: updatedAt.toIso8601String(),
  };

  ProfileModel copyWith({
    String? id,
    String? email,
    String? username,
    DateTime? birthday,
    String? bio,
    String? gender,
    String? firstName,
    String? lastName,
    String? avatarUrl,
    String? role,
    String? country,
    String? region,
    String? province,
    String? cityMunicipal,
    String? barangay,
    String? street,
    String? postalCode,
    String? referralCode,
    DateTime? lastLogin,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProfileModel(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      birthday: birthday ?? this.birthday,
      bio: bio ?? this.bio,
      gender: gender ?? this.gender,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      role: role ?? this.role,
      country: country ?? this.country,
      region: region ?? this.region,
      province: province ?? this.province,
      cityMunicipal: cityMunicipal ?? this.cityMunicipal,
      barangay: barangay ?? this.barangay,
      street: street ?? this.street,
      postalCode: postalCode ?? this.postalCode,
      referralCode: referralCode ?? this.referralCode,
      lastLogin: lastLogin ?? this.lastLogin,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'UserModel(id: $id, email: $email, username: $username, birthday: $birthday, bio: $bio, gender: $gender, firstName: $firstName, lastName: $lastName, avatarUrl: $avatarUrl, role: $role, country: $country, region: $region, province: $province, cityMunicipal: $cityMunicipal, barangay: $barangay, street: $street, postalCode: $postalCode, referralCode: $referralCode, lastLogin: $lastLogin, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}
