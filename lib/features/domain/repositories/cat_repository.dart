import '../entities/breed_entity.dart';
import '../entities/cat_entity.dart';

abstract class CatRepository {
  Future<CatEntity> getRandomCatWithBreed();
  Future<List<BreedEntity>> getBreeds();
}
