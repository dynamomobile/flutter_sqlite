class DBEntry {
  final int id;
  final String name;

  DBEntry({this.id, this.name});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }
}
