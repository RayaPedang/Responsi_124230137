class News {
  final String id;
  final String title;
  final String authors;
  final String url;
  final String imageUrl;
  final String newsSite;
  final String summary;
  final String publishedAt;
  final String updatedAt;
  final String featured;
  final String launches;
  final String events;

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

  // Factory untuk membuat object dari JSON API
  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      id: json['amiiboSeries'] ?? 'Unknown',
      title: json['character'] ?? 'Unknown',
      authors: json['gameSeries'] ?? 'Unknown',
      url: json['head'] ?? '',
      imageUrl: json['image'] ?? '',
      newsSite: json['name'] ?? 'Unknown',
      summary: json['release'] != null
          ? Release.fromJson(json['release']).toString()
          : 'Unknown',
      publishedAt: json['tail'] ?? '',
      updatedAt: json['type'] ?? 'Unknown',
      featured: json['type'] ?? 'Unknown',
      launches: json['type'] ?? 'Unknown',
      events: json['type'] ?? 'Unknown',
    );
  }

  // Mengubah object ke Map (untuk disimpan di Shared Preferences)
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'authors': authors,
    'url': url,
    'imageUrl': imageUrl,
    'newsSite': newsSite,
    'summary': summary,
    'publishedAt': publishedAt,
    'updatedAt': updatedAt,
    'featured': featured,
    'launches': launches,
    'events': events,
  };
}

class Release {
  final String? au;
  final String? eu;
  final String? jp;
  final String? na;

  Release({this.au, this.eu, this.jp, this.na});

  factory Release.fromJson(Map<String, dynamic> json) {
    return Release(
      au: json['au'],
      eu: json['eu'],
      jp: json['jp'],
      na: json['na'],
    );
  }

  Map<String, dynamic> toJson() => {'au': au, 'eu': eu, 'jp': jp, 'na': na};
}
