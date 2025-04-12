class Employer {
  final String name;
  final String email;
  final String password;
  final String companyName;
  final String role;

  Employer({
    required this.name,
    required this.email,
    required this.password,
    required this.companyName,
    required this.role,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'companyName': companyName,
      'role': role,
    };
  }
}
