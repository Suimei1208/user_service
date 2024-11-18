class User {
  final String id;
  final String email;
  final String phone;
  final String role;
  final String name;

  User({
    required this.id,
    required this.email,
    required this.phone,
    required this.role,
    required this.name,
  });


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'phone': phone,
      'role': role,
      'name': name,
    };
  }


  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? "",
      email: json['email'] ?? "",
      phone: json['phone'] ?? "",
      role: json['role'] ?? "",
      name: json['name'] ?? "",
    );
  }
}
