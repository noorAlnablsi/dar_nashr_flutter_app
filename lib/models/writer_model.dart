class Writer {
  final int id;
  final String username;
  final String? bio;
  final String? writerBio;
  final int publishedBooksCount;
  final bool isFeaturedWriter;

  Writer({
    required this.id,
    required this.username,
    this.bio,
    this.writerBio,
    required this.publishedBooksCount,
    required this.isFeaturedWriter,
  });

  factory Writer.fromJson(Map<String, dynamic> json) {
    return Writer(
      id: json['id'],
      username: json['username'],
      bio: json['bio'],
      writerBio: json['writer_bio'],
      publishedBooksCount: json['published_books_count'],
      isFeaturedWriter: json['is_featured_writer'],
    );
  }
}
