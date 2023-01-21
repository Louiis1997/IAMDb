class Top {
  final int malId;
  final String? imageUrl;
  final String title;
  final String? titleEnglish;
  final String? youtubeId;

  Top({
    required this.malId,
    required this.imageUrl,
    required this.title,
    required this.titleEnglish,
    required this.youtubeId,
  });

  factory Top.fromJson(Map<String, dynamic> json){
    int malId = json['mal_id'];
    String imageUrl = json['images']['jpg']['image_url'] ?? "";
    String title = json['title'];
    String titleEnglish = json['title_english'] ?? json['title'];
    String youtubeId = json['trailer']['youtube_id'] ?? "dQw4w9WgXcQ";

    return Top(
      malId: malId,
      imageUrl: imageUrl,
      title: title,
      titleEnglish: titleEnglish,
      youtubeId: youtubeId,
    );
  }

  @override
  String toString() {
    return "Anime(malId: $malId, imageUrl: $imageUrl, title: $title, "
        "titleEnglish: $titleEnglish, youtubeId: $youtubeId)";
  }
}