class BreedEntity {
  final String id;
  final String name;
  final String description;
  final String origin;
  final String temperament;
  final int intelligence;
  final int energyLevel;
  final int affectionLevel;
  final int socialNeeds;

  const BreedEntity({
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
}
