import 'breed_entity.dart';

class CatEntity {
  final String id;
  final String url;
  final int width;
  final int height;
  final String? breedId;
  final String? breedName;
  final BreedEntity? fullBreed;
  final String? generatedName;

  const CatEntity({
    required this.id,
    required this.url,
    required this.width,
    required this.height,
    this.breedId,
    this.breedName,
    this.fullBreed,
    this.generatedName,
  });

  CatEntity copyWith({String? generatedName}) {
    return CatEntity(
      id: id,
      url: url,
      width: width,
      height: height,
      breedId: breedId,
      breedName: breedName,
      fullBreed: fullBreed,
      generatedName: generatedName ?? this.generatedName,
    );
  }
}
