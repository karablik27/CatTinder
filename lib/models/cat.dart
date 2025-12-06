import 'breed.dart';

class Cat {
  final String id;
  final String url;
  final int width;
  final int height;

  final String? breedID;
  final String? breedName;
  final Breed? fullBreed;

  final String? generatedName;

  Cat({
    required this.id,
    required this.url,
    required this.width,
    required this.height,
    this.breedID,
    this.breedName,
    this.fullBreed,
    this.generatedName,
  });

  factory Cat.fromJson(Map<String, dynamic> json) {
    final breeds =
        (json['breeds'] as List<dynamic>?)?.cast<Map<String, dynamic>>() ?? [];

    final breedJson = breeds.isNotEmpty ? breeds.first : null;

    return Cat(
      id: json['id'] as String,
      url: json['url'] as String,
      width: json['width'] as int? ?? 0,
      height: json['height'] as int? ?? 0,
      breedID: breedJson?['id'] as String?,
      breedName: breedJson?['name'] as String?,
      fullBreed: breedJson != null ? Breed.fromJson(breedJson) : null,
      generatedName: null,
    );
  }

  Cat copyWith({String? generatedName}) {
    return Cat(
      id: id,
      url: url,
      width: width,
      height: height,
      breedID: breedID,
      breedName: breedName,
      fullBreed: fullBreed,
      generatedName: generatedName ?? this.generatedName,
    );
  }
}
