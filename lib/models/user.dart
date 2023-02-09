class User {
  final String id;
  final String username;
  final String firstname;
  final String lastname;
  final String email;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;
  final String? bio;
  final String? birthdate;
  final String? status;

  User({
    required this.id,
    required this.username,
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.bio,
    required this.birthdate,
    required this.status,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    String id = json['id'];
    String username = json['username'];
    String firstname = json['firstName'];
    String lastname = json['lastName'];
    String email = json['email'];
    String createdAt = json['createdAt'];
    String updatedAt = json['updatedAt'];
    String deletedAt = json['deletedAt'] ?? "";
    String bio = json['bio'] ?? "";
    String birthdate = json['birthdate'] ?? "";
    String status = json['status'] ?? "";

    return User(
      id: id,
      username: username,
      firstname: firstname,
      lastname: lastname,
      email: email,
      createdAt: createdAt,
      updatedAt: updatedAt,
      deletedAt: deletedAt,
      bio: bio,
      birthdate: birthdate,
      status: status,
    );
  }

  @override
  String toString() {
    return 'User{id: $id, username: $username, firstname: $firstname, '
        'lastname: $lastname, email: $email, createdAt: $createdAt, '
        'updatedAt: $updatedAt, deletedAt: $deletedAt, bio: $bio, '
        'birthdate: $birthdate, status: $status}';
  }
}
