class Anime {
  final int malId;
  final String? imageUrl;
  final String title;
  final String? titleEnglish;
  final String? type;
  final int? episodes;
  final String? status;

  //final String? airedString;
  final String? duration;
  final num? score;
  final int? scoredBy;
  final int? rank;
  final String? synopsis;
  final String? background;
  final String? season;
  final int? year;
  final List<String> producersName;
  final List<String> licensorsName;
  final List<String> studiosName;
  final List<String> genresName;

  Anime({
    required this.malId,
    required this.imageUrl,
    required this.title,
    required this.titleEnglish,
    required this.type,
    required this.episodes,
    required this.status,
    //required this.airedString,
    required this.duration,
    required this.score,
    required this.scoredBy,
    required this.rank,
    required this.synopsis,
    required this.background,
    required this.season,
    required this.year,
    required this.producersName,
    required this.licensorsName,
    required this.studiosName,
    required this.genresName,
  });

  factory Anime.fromJson(Map<String, dynamic> json) {
    int malId = json['mal_id'];
    String imageUrl = json['images']['jpg']['image_url'] ?? "";
    String title = json['title'];
    String titleEnglish = json['title_english'] ?? json['title'];
    String type = json['type'] ?? "";
    int episodes = json['episodes'] ?? 0;
    String status = json['status'] ?? "";
    //String airedString = json['aired']['string'] ?? "";
    String duration = json['duration'] ?? "";
    num score = json['score'] ?? 0.00;
    int scoredBy = json['scored_by'] ?? 0;
    int rank = json['rank'] ?? 0;
    String synopsis = json['synopsis'] ?? "";
    String background = json['background'] ?? "";
    String season = json['season'] ?? "";
    int year = json['year'] ?? 0;
    List<String> producersName = [];
    List<String> licensorsName = [];
    List<String> studiosName = [];
    List<String> genresName = [];

    for (var producer in json['producers']) {
      producersName.add(producer['name']);
    }

    for (var licensor in json['licensors']) {
      licensorsName.add(licensor['name']);
    }

    for (var studio in json['studios']) {
      studiosName.add(studio['name']);
    }

    for (var genre in json['genres']) {
      genresName.add(genre['name']);
    }

    return Anime(
      malId: malId,
      imageUrl: imageUrl,
      title: title,
      titleEnglish: titleEnglish,
      type: type,
      episodes: episodes,
      status: status,
      //airedString: airedString,
      duration: duration,
      score: score,
      scoredBy: scoredBy,
      rank: rank,
      synopsis: synopsis,
      background: background,
      season: season,
      year: year,
      producersName: producersName,
      licensorsName: licensorsName,
      studiosName: studiosName,
      genresName: genresName,
    );
  }

  @override
  String toString() {
    return 'Anime{malId: $malId, imageUrl: $imageUrl, '
        'title: $title, titleEnglish: $titleEnglish, type: $type, '
        'episodes: $episodes, status: $status, '
        'duration: $duration, score: $score, scoredBy: $scoredBy, '
        'rank: $rank, synopsis: $synopsis, background: $background, '
        'season: $season, year: $year, producersName: $producersName, '
        'licensorsName: $licensorsName, studiosName: $studiosName, '
        'genresName: $genresName}';
  }
}
