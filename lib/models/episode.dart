class Episode {
  final int malId;
  final String title;
  final String? duration;
  final String? aired;
  final bool? filler;
  final bool? recap;

  Episode({
    required this.malId,
    required this.title,
    required this.duration,
    required this.aired,
    required this.filler,
    required this.recap,
  });

  factory Episode.fromJson(Map<String, dynamic> json) {
    int malId = json['mal_id'];
    String title = json['title'];
    String duration = json['duration'] ?? "";
    String aired = json['aired'] ?? "";
    bool filler = json['filler'] ?? false;
    bool recap = json['recap'] ?? false;

    return Episode(
      malId: malId,
      title: title,
      duration: duration,
      aired: aired,
      filler: filler,
      recap: recap,
    );
  }

  @override
  String toString() {
    return 'Episode{malId: $malId, title: $title, duration: $duration, '
        'aired: $aired, filler: $filler, recap: $recap}';
  }
}
