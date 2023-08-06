// todo model class
class Todo {
  final String title;
  final String createdAt;
  final int id;
  final String? updatedAt;

  const Todo({
    required this.title,
    required this.createdAt,
    required this.id,
    this.updatedAt,
  });
}
