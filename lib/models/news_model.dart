class NewsModel {
  final int id;
  final String title;
  final String url;
  final String imageUrl;
  final String newsSite;
  final String summary;
  final String publishedAt;

  NewsModel({
    required this.id,
    required this.title,
    required this.url,
    required this.imageUrl,
    required this.newsSite,
    required this.summary,
    required this.publishedAt,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
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
