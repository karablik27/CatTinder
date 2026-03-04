import '../entities/breed_entity.dart';
import '../repositories/cat_repository.dart';

class GetBreedsUseCase {
  final CatRepository repository;

  const GetBreedsUseCase(this.repository);

  Future<List<BreedEntity>> call() {
    return repository.getBreeds();
  }
}
