class Label {
  int id;
  int updatedDate;
  String label;

  Label({
    this.id,
    this.label,
    this.updatedDate,
  });
// Convert a Daliy into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'updatedDate': updatedDate,
      'label': label,
    };
  }
}
