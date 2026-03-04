import '../../domain/entities/cat_entity.dart';
import 'breed.dart';

class CatModel {
  final String id;
  final String url;
  final int width;
  final int height;
  final String? breedId;
  final String? breedName;
  final BreedModel? fullBreed;

  const CatModel({
    required this.id,
    required this.url,
    required this.width,
    required this.height,
    this.breedId,
    this.breedName,
    this.fullBreed,
  });

  factory CatModel.fromJson(Map<String, dynamic> json) {
    final breeds =
        (json['breeds'] as List<dynamic>?)?.cast<Map<String, dynamic>>() ?? [];
    final breedJson = breeds.isNotEmpty ? breeds.first : null;

    return CatModel(
      id: json['id'] as String,
      url: json['url'] as String,
      width: json['width'] as int? ?? 0,
      height: json['height'] as int? ?? 0,
      breedId: breedJson?['id'] as String?,
      breedName: breedJson?['name'] as String?,
      fullBreed: breedJson != null ? BreedModel.fromJson(breedJson) : null,
    );
  }

  CatEntity toEntity() {
    return CatEntity(
      id: id,
      url: url,
      width: width,
      height: height,
      breedId: breedId,
      breedName: breedName,
      fullBreed: fullBreed?.toEntity(),
      generatedName: null,
    );
  }
}
