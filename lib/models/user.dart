class User {
  final int? id;
  final String? userName;
  final int? age;

  const User({this.id, this.userName, this.age});

  factory User.fromMap(Map<String, dynamic> json) =>
      User(id: json["id"], userName: json["userName"], age: json["age"]);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userName': userName,
      'age': age,
    };
  }
}
