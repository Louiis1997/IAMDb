class GlobalRating {
  final double average;
  final String presentableAverage;
  final int totalCount;

  GlobalRating({
    required this.average,
    required this.presentableAverage,
    required this.totalCount,
  });

  factory GlobalRating.fromJson(Map<String, dynamic> json) {
    double average = json['average'];
    String presentableAverage = json['presentableAverage'];
    int totalCount = json['totalCount'];

    return GlobalRating(
      average: average,
      presentableAverage: presentableAverage,
      totalCount: totalCount,
    );
  }
}
