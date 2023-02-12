class Character {
  final int malId;
  final String? imageUrl;
  final String name;

  Character({
    required this.malId,
    required this.imageUrl,
    required this.name,
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    int malId = json['character']['mal_id'];
    String imageUrl = json['character']['images']['jpg']['image_url'] ?? "";
    String name = json['character']['name'];

    return Character(
      malId: malId,
      imageUrl: imageUrl,
      name: name,
    );
  }

  @override
  String toString() {
    return 'Character{malId: $malId, imageUrl: $imageUrl, name: $name}';
  }
}
