class Manga {
  final int malId;
  final String? imageUrl;
  final String title;
  final String? titleEnglish;
  final String? type;
  final int? chapters;
  final int? volumes;
  final String? status;
  final String? publishedString;
  final double? score;
  final int? scoredBy;
  final int? rank;
  final String? synopsis;
  final String? background;
  final List<String> authorsName;
  final List<String> serializationsName;
  final List<String> genresName;

  Manga({
    required this.malId,
    required this.imageUrl,
    required this.title,
    required this.titleEnglish,
    required this.type,
    required this.chapters,
    required this.volumes,
    required this.status,
    required this.publishedString,
    required this.score,
    required this.scoredBy,
    required this.rank,
    required this.synopsis,
    required this.background,
     required this.authorsName,
    required this.serializationsName,
    required this.genresName,
  });

  factory Manga.fromJson(Map<String, dynamic> json){
    int malId = json['mal_id'];
    String imageUrl = json['images']['jpg']['image_url'] ?? "";
    String title = json['title'];
    String titleEnglish = json['title_english'] ?? json['title'];
    String type = json['type'] ?? "";
    int chapters = json['chapters'] ?? 0;
    int volumes = json['volumes'] ?? 0;
    String status = json['status'] ?? "";
    String publishedString = json['published']['string'] ?? "";
    double score = json['score'] ?? 0;
    int scoredBy = json['scored_by'] ?? 0;
    int rank = json['rank'] ?? 0;
    String synopsis = json['synopsis'] ?? "";
    String background = json['background'] ?? "";
    List<String> authorsName = [];
    List<String> serializationsName = [];
    List<String> genresName = [];

    for (var authors in json['authors']){
      authorsName.add(authors['name']);
    }

    for (var serializations in json['serializations']){
      serializationsName.add(serializations['name']);
    }

    for (var genre in json['genres']){
      genresName.add(genre['name']);
    }

    return Manga(
      malId: malId,
      imageUrl: imageUrl,
      title: title,
      titleEnglish: titleEnglish,
      type: type,
      chapters: chapters,
      volumes: volumes,
      status: status,
      publishedString: publishedString,
      score: score,
      scoredBy: scoredBy,
      rank: rank,
      synopsis: synopsis,
      background: background,
      authorsName: authorsName,
      serializationsName: serializationsName,
      genresName: genresName,
    );
  }

  @override
  String toString() {
    return 'Manga{malId: $malId, imageUrl: $imageUrl, title: $title, '
        'titleEnglish: $titleEnglish, type: $type, chapters: $chapters, '
        'volumes: $volumes, status: $status, publishedString: $publishedString, '
        'score: $score, scoredBy: $scoredBy, rank: $rank, synopsis: $synopsis, '
        'background: $background, authorsName: $authorsName, '
        'serializationsName: $serializationsName, genresName: $genresName}';
  }
}