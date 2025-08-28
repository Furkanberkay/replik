class CastMember {
  final int id;
  final String name;
  final String character;
  final String? profilePath;

  CastMember({
    required this.id,
    required this.name,
    required this.character,
    required this.profilePath,
  });

  factory CastMember.fromJson(Map<String, dynamic> j) => CastMember(
    id: j['id'],
    name: j['name'] ?? '',
    character: j['character'] ?? '',
    profilePath: j['profile_path'],
  );

  String get profileUrl =>
      profilePath != null ? 'https://image.tmdb.org/t/p/w185$profilePath' : '';
}
