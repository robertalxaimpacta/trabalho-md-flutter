class Role {
  int? id;
  String name;
  String description;

  Role(this.id, this.name, this.description);

  Role.fromObject(dynamic obj)
      : id = obj['id'],
        name = obj['name'],
        description = obj['description'];

  dynamic toObject() {
    return {
      'id': id,
      'name': name,
      'description': description,
    };
  }
}
