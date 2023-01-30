import 'anime.dart';
import 'user.dart';

class Rating {
  final String id;
  final int animeId;
  final Anime anime;
  final String userId;
  final User user;
  final double rating;
  final String presentableRating;
  final String createdAt;
  final String updatedAt;
  final String deletedAt;

  Rating({
    required this.id,
    required this.animeId,
    required this.anime,
    required this.userId,
    required this.user,
    required this.rating,
    required this.presentableRating,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  factory Rating.fromJson(Map<String, dynamic> json) {
    String id = json['id'];
    int animeId = json['animeId'];
    Anime anime = Anime.fromJson(json['anime']);
    String userId = json['userId'];
    User user = User.fromJson(json['user']);
    double rating = json['rating'];
    String presentableRating = json['presentableRating'];
    String createdAt = json['createdAt'];
    String updatedAt = json['updatedAt'];
    String deletedAt = json['deletedAt'];

    return Rating(
      id: id,
      animeId: animeId,
      anime: anime,
      userId: userId,
      user: user,
      rating: rating,
      presentableRating: presentableRating,
      createdAt: createdAt,
      updatedAt: updatedAt,
      deletedAt: deletedAt,
    );
  }

  @override
  String toString() {
    return 'Rating{id: $id, animeId: $animeId, anime: $anime, userId: $userId, '
        'user: $user, rating: $rating, presentableRating: $presentableRating, '
        'createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt}';
  }
}
