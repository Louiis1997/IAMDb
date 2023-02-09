class TopAnime {
  final int malId;
  final String? imageUrl;
  final String title;
  final String? titleEnglish;
  final String? youtubeId;
  final String? trailerImage;

  TopAnime({
    required this.malId,
    required this.imageUrl,
    required this.title,
    required this.titleEnglish,
    required this.youtubeId,
    required this.trailerImage,
  });

  factory TopAnime.fromJson(Map<String, dynamic> json) {
    int malId = json['mal_id'];
    String imageUrl = json['images']['jpg']['image_url'] ?? "";
    String title = json['title'];
    String titleEnglish = json['title_english'] ?? json['title'];
    String youtubeId = json['trailer']['youtube_id'] ?? "dQw4w9WgXcQ";
    String trailerImage = json['trailer']['images']['large_image_url'] ??
        "https://i.ytimg.com/vi/36VSV-zw18o/maxresdefault.jpg";

    return TopAnime(
      malId: malId,
      imageUrl: imageUrl,
      title: title,
      titleEnglish: titleEnglish,
      youtubeId: youtubeId,
      trailerImage: trailerImage,
    );
  }

  @override
  String toString() {
    return 'TopAnime{malId: $malId, imageUrl: $imageUrl, '
        'title: $title, titleEnglish: $titleEnglish, '
        'youtubeId: $youtubeId, trailerImage: $trailerImage}';
  }
}
