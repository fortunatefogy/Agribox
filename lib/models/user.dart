class User {
  final String? id;
  final String name;
  final String email;
  final String password;
  final String phone;

  User({
    this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
  });

  // Convert User object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'phone': phone,
    };
  }

  // Create User object from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id']?.toString(),
      name: json['name'],
      email: json['email'],
      password: json['password'] ?? '',
      phone: json['phone'],
    );
  }
}