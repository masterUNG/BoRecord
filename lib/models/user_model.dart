import 'dart:convert';

class UserModel {
  final String id;
  final String name;
  final String user;
  final String password;
  UserModel({
    required this.id,
    required this.name,
    required this.user,
    required this.password,
  });

  UserModel copyWith({
    String? id,
    String? name,
    String? user,
    String? password,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      user: user ?? this.user,
      password: password ?? this.password,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'user': user,
      'password': password,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      name: map['name'],
      user: map['user'],
      password: map['password'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, user: $user, password: $password)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is UserModel &&
      other.id == id &&
      other.name == name &&
      other.user == user &&
      other.password == password;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      user.hashCode ^
      password.hashCode;
  }
}
