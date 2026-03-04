import '../entities/cat_entity.dart';
import '../repositories/cat_name_repository.dart';
import '../repositories/cat_repository.dart';

class GetRandomCatWithGeneratedNameUseCase {
  final CatRepository catRepository;
  final CatNameRepository catNameRepository;

  const GetRandomCatWithGeneratedNameUseCase({
    required this.catRepository,
    required this.catNameRepository,
  });

  Future<CatEntity> call() async {
    final cat = await catRepository.getRandomCatWithBreed();
    final generatedName = await catNameRepository.generateName(cat.url);
    return cat.copyWith(generatedName: generatedName);
  }
}
