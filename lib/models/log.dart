class Log {
  late int grammage, id;
  late DateTime createdAt;

  Log(this.id, this.grammage, this.createdAt, void destroy);
  Log.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    grammage = json["grammage"];
    createdAt = json["createdAt"];
  }
}
