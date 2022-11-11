class NoteModel {
  String? id;
  String? title;
  String? content;
  String? date;
  int? colorId;

  NoteModel({
    this.id,
    this.title,
    this.content,
    this.date,
    this.colorId,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'date': date,
      'colorId': colorId,
    };
  }

  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      date: json['date'] as String,
      colorId: json['colorId'] as int,
    );
  }

  @override
  String toString() {
    return 'NoteModel{id: $id, title: $title, content: $content, date: $date, colorId: $colorId}';
  }
}
