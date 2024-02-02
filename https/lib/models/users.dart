class User {
  final int id;
  final String name;
  final String email;
  final int number;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.number,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      number: json['number'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'number': number,
    };
  }
}
