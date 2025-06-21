class Article {
  final String uuid;
  final String? title;
  final String? content;
  final String? image;
  final String? author;
  final String? createdAt;
  final String? updatedAt;

  Article({
    required this.uuid,
    this.title,
    this.content,
    this.image,
    this.author,
    this.createdAt,
    this.updatedAt,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      uuid: json['uuid'] ?? '',
      title: json['title'],
      content: json['content'],
      image: json['image'],
      author: json['author'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
