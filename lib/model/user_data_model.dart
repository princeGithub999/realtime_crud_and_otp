class UserDataModel {
  String id;
  String name;
  String email;

  UserDataModel({
    required this.id,
    required this.name,
    required this.email,
  });

  // Convert UserDataModel instance to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
    };
  }

  // Create UserDataModel instance from Map
  factory UserDataModel.fromJson(Map<String, dynamic> json) {
    return UserDataModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
    );
  }
}
