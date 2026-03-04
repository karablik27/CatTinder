import '../../domain/repositories/cat_name_repository.dart';
import '../datasources/cat_name_remote_data_source.dart';

class CatNameRepositoryImpl implements CatNameRepository {
  final CatNameRemoteDataSource remoteDataSource;

  const CatNameRepositoryImpl(this.remoteDataSource);

  @override
  Future<String> generateName(String imageUrl) {
    return remoteDataSource.generateCatName(imageUrl);
  }
}
