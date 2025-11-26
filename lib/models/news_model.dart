class News {
  final int id;
  final String title;
  final String url;
  final String imageUrl;
  final String newsSite;
  final String summary;
  final String publishedAt;

  News({
    required this.id,
    required this.title,
    required this.url,
    required this.imageUrl,
    required this.newsSite,
    required this.summary,
    required this.publishedAt,
  });

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      id: json['id'],
      title: json['title'] ?? 'No Title',
      url: json['url'] ?? '',
      imageUrl: json['image_url'] ?? 'https://via.placeholder.com/150',
      newsSite: json['news_site'] ?? '',
      summary: json['summary'] ?? 'No Summary',
      publishedAt: json['published_at'] ?? '',
    );
  }
}
