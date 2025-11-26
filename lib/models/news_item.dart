class NewsItem {
  final int id;
  final String title;
  final String imageUrl;
  final String summary;
  final String url;
  final String publishedAt;
  final String newsSite;

  NewsItem({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.summary,
    required this.url,
    required this.publishedAt,
    required this.newsSite,
  });

  factory NewsItem.fromJson(Map<String, dynamic> json) {
    return NewsItem(
      id: json['id'],
      title: json['title'],
      imageUrl: json['image_url'] ?? 'https://via.placeholder.com/150',
      summary: json['summary'] ?? 'No summary available.',
      url: json['url'],
      publishedAt: json['published_at'],
      newsSite: json['news_site'] ?? '',
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NewsItem && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
