class Episode {
  final int malId;
  final String title;
  final String? duration;
  final String? aired;
  final double? score;
  final bool? filler;

  Episode({
    required this.malId,
    required this.title,
    required this.duration,
    required this.aired,
    required this.score,
    required this.filler,
  });

  factory Episode.fromJson(Map<String, dynamic> json){
    int malId = json['mal_id'];
    String title = json['title'];
    String duration = json['duration'] ?? "";
    double score = json['score'] ?? 0;
    String aired = json['aired'] ?? "";
    bool filler = json['filler'] ?? false;

    return Episode(
      malId: malId,
      title: title,
      duration: duration,
      score: score,
      aired: aired,
      filler: filler,
    );
  }

  @override
  String toString() {
    return 'Episode{malId: $malId, title: $title, duration: $duration, '
        'aired: $aired, score: $score, filler: $filler}';
  }
}