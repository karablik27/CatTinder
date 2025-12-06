class Breed {
  final String id;
  final String name;
  final String description;
  final String origin;
  final String temperament;

  final int intelligence;
  final int energyLevel;
  final int affectionLevel;
  final int socialNeeds;

  Breed({
    required this.id,
    required this.name,
    required this.description,
    required this.origin,
    required this.temperament,
    required this.intelligence,
    required this.energyLevel,
    required this.affectionLevel,
    required this.socialNeeds,
  });

  factory Breed.fromJson(Map<String, dynamic> json) {
    return Breed(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      origin: json['origin'] as String? ?? '',
      temperament: json['temperament'] as String? ?? '',
      intelligence: json['intelligence'] as int? ?? 0,
      energyLevel: json['energy_level'] as int? ?? 0,
      affectionLevel: json['affection_level'] as int? ?? 0,
      socialNeeds: json['social_needs'] as int? ?? 0,
    );
  }
}
