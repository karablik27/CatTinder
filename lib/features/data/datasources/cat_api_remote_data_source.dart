import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../app/app_secrets.dart';
import '../models/breed.dart';
import '../models/cat.dart';

class CatApiRemoteDataSource {
  static const String _baseUrl = 'https://api.thecatapi.com/v1';

  Future<dynamic> _get(String path) async {
    final url = Uri.parse('$_baseUrl$path');
    final headers = <String, String>{};

    if (AppSecrets.hasCatApiKey) {
      headers['x-api-key'] = AppSecrets.catApiKey;
    }

    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode != 200) {
        throw CatApiException('Ошибка: сервер вернул ${response.statusCode}');
      }
      return jsonDecode(response.body);
    } catch (e) {
      throw CatApiException('Ошибка сети: $e');
    }
  }

  Future<CatModel> getImageInfo(String id) async {
    final json = await _get('/images/$id');
    return CatModel.fromJson(json as Map<String, dynamic>);
  }

  Future<CatModel> getRandomCatWithBreed() async {
    final json = await _get('/images/search') as List<dynamic>;

    if (json.isEmpty || json.first['id'] == null) {
      throw CatApiException('API вернул пустой список');
    }

    final id = json.first['id'] as String;
    return getImageInfo(id);
  }

  Future<List<BreedModel>> getBreeds() async {
    final json = await _get('/breeds') as List<dynamic>;
    return json
        .map((b) => BreedModel.fromJson(b as Map<String, dynamic>))
        .toList();
  }
}

class CatApiException implements Exception {
  final String message;

  CatApiException(this.message);

  @override
  String toString() => 'CatApiException: $message';
}
