import '../../domain/entities/breed_entity.dart';
import '../../domain/entities/cat_entity.dart';
import '../../domain/repositories/cat_repository.dart';
import '../datasources/cat_api_remote_data_source.dart';

class CatRepositoryImpl implements CatRepository {
  final CatApiRemoteDataSource remoteDataSource;

  const CatRepositoryImpl(this.remoteDataSource);

  @override
  Future<CatEntity> getRandomCatWithBreed() async {
    final model = await remoteDataSource.getRandomCatWithBreed();
    return model.toEntity();
  }

  @override
  Future<List<BreedEntity>> getBreeds() async {
    final models = await remoteDataSource.getBreeds();
    return models.map((model) => model.toEntity()).toList();
  }
}
