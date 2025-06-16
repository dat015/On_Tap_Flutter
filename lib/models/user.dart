class User {
  int? id;
  String? name;
  String? email;
  String? phone;
  DateTime? dateOfBirth;
  String? gender;
  String? password;

  User({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.dateOfBirth,
    this.gender,
    this.password,
  });

  // chuyển user sang map để lưu vào sqlite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'password': password,
      'gender': gender,
    };
  }

  // chuyển map sang user
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
      dateOfBirth: DateTime.tryParse(map['dateOfBirth'] ?? ''),
      password: map['password'],
      gender: map['gender'],
    );
  }
}
