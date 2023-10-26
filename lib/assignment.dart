class Assignment {
  int? id;
  String? title;
  String? description;
  String? deadline;
  String? created_at;
  String? updated_at;
  Assignment({this.id, this.title, this.description, this.deadline, this.created_at, this.updated_at});
  factory Assignment.fromJson(Map<String, dynamic> obj) {
    return Assignment(
        id: obj['id'],
        title: obj['title'],
        description: obj['description'],
        deadline: obj['deadline'],
        created_at: obj['created_at'],
        updated_at: obj['updated_at']);
  }
  
}
