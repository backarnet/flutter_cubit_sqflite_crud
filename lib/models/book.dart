class Book {
  final int? id;
  final String title;
  final int pages;
  final int userId;
  String? userName;

  Book({
    this.id,
    required this.title,
    required this.pages,
    required this.userId,
  });

  factory Book.fromMap(Map<String, dynamic> json) => Book(
        id: json["id"],
        title: json["title"],
        pages: json["pages"],
        userId: json["userId"],
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'pages': pages,
      'userId': userId,
    };
  }
}
