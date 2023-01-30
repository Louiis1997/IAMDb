import 'anime.dart';
import 'user.dart';

class Agenda {
  final String id;
  final int animeId;
  final Anime anime;
  final String userId;
  final User user;
  final Object status;
  final String createdAt;
  final String updatedAt;
  final String deletedAt;

  Agenda({
    required this.id,
    required this.animeId,
    required this.anime,
    required this.userId,
    required this.user,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  factory Agenda.fromJson(Map<String, dynamic> json) {
    String id = json['id'];
    int animeId = json['animeId'];
    Anime anime = Anime.fromJson(json['anime']);
    String userId = json['userId'];
    User user = User.fromJson(json['user']);
    Object status = json['status'];
    String createdAt = json['createdAt'];
    String updatedAt = json['updatedAt'];
    String deletedAt = json['deletedAt'];

    return Agenda(
      id: id,
      animeId: animeId,
      anime: anime,
      userId: userId,
      user: user,
      status: status,
      createdAt: createdAt,
      updatedAt: updatedAt,
      deletedAt: deletedAt,
    );
  }

  @override
  String toString() {
    return 'Agenda{id: $id, animeId: $animeId, anime: $anime, userId: $userId, '
        'user: $user, status: $status, createdAt: $createdAt, '
        'updatedAt: $updatedAt, deletedAt: $deletedAt}';
  }
}