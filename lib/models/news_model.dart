class News {
  final int id;
  final String title;
  final List<String> authors;
  final String url;
  final String imageUrl;
  final String newsSite;
  final String summary;
  final String publishedAt;
  final String updatedAt;
  final bool featured;
  final List<dynamic> launches;
  final List<dynamic> events;

  News({
    required this.id,
    required this.title,
    required this.authors,
    required this.url,
    required this.imageUrl,
    required this.newsSite,
    required this.summary,
    required this.publishedAt,
    required this.updatedAt,
    required this.featured,
    required this.launches,
    required this.events,
  });

  // Factory untuk membuat object dari JSON API Space Flight News
  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'Unknown',
      authors: List<String>.from(json['authors'] ?? []),
      url: json['url'] ?? '',
      imageUrl: json['image_url'] ?? '',
      newsSite: json['news_site'] ?? 'Unknown',
      summary: json['summary'] ?? 'No summary available',
      publishedAt: json['published_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      featured: json['featured'] ?? false,
      launches: json['launches'] ?? [],
      events: json['events'] ?? [],
    );
  }

  // Mengubah object ke Map (untuk disimpan di Shared Preferences)
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'authors': authors,
    'url': url,
    'image_url': imageUrl,
    'news_site': newsSite,
    'summary': summary,
    'published_at': publishedAt,
    'updated_at': updatedAt,
    'featured': featured,
    'launches': launches,
    'events': events,
  };
}
