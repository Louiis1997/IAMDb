class TopManga {
  final int malId;
  final String? imageUrl;
  final String title;
  final String? titleEnglish;

  TopManga({
    required this.malId,
    required this.imageUrl,
    required this.title,
    required this.titleEnglish,
  });

  factory TopManga.fromJson(Map<String, dynamic> json){
    int malId = json['mal_id'];
    String imageUrl = json['images']['jpg']['image_url'] ?? "";
    String title = json['title'];
    String titleEnglish = json['title_english'] ?? json['title'];

    return TopManga(
      malId: malId,
      imageUrl: imageUrl,
      title: title,
      titleEnglish: titleEnglish,
    );
  }

  @override
  String toString() {
    return 'TopManga{malId: $malId, imageUrl: $imageUrl, '
        'title: $title, titleEnglish: $titleEnglish}';
  }
}