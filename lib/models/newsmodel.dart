class NewsArticle {
  final String title;
  final String description;
  final String publishedAt;
  final String url; // ✅ Add this

  NewsArticle({
    required this.title,
    required this.description,
    required this.publishedAt,
    required this.url, // ✅ Add this
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      title: json['title'] ?? 'No Title',
      description: json['description'] ?? 'No Description',
      publishedAt: json['publishedAt'] ?? '',
      url: json['url'] ?? '', // ✅ Parse this
    );
  }
}
