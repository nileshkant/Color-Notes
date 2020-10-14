class Note {
  int id;
  String title;
  String noteBody;
  int createdDate;
  int updatedDate;
  String background;

  Note({
    this.id,
    this.title,
    this.noteBody,
    this.createdDate,
    this.updatedDate,
    this.background,
  });
// Convert a Daliy into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'noteBody': noteBody,
      'createdDate': createdDate,
      'updatedDate': updatedDate,
      'background': background,
    };
  }
}
