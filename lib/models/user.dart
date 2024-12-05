class User {
  int? id;
  String name;
  String username;
  String? password;
  List<String>? roles;
  String? token;

  User(this.id, this.name, this.username, this.password, this.roles);

  User.fromObject(dynamic obj)
    : id = obj['id'],
      name = obj['name'],
      username = obj['username'],
      password = null,
      roles = obj['roles'] != null ? List<String>.from(obj['roles']) : null,
      token = obj['token'];

  dynamic toObject() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'password': password,
      'roles': roles,
      'token': token,
    };
  }

}