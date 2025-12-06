import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/cat.dart';
import '../models/breed.dart';

class CatApiService {
  static const String _baseUrl = 'https://api.thecatapi.com/v1';

  static const Map<String, String> _headers = {
    "x-api-key":
        "live_mQANIwLhgNEgy8AJfq4RKD1heTOHSUwSPGZ7z8SvLWKHHHafG6RNP6yns6eN4XP8",
  };

  Future<dynamic> _get(String path) async {
    final url = Uri.parse("$_baseUrl$path");

    try {
      final response = await http.get(url, headers: _headers);

      if (response.statusCode != 200) {
        throw CatApiException("Ошибка: сервер вернул ${response.statusCode}");
      }

      return jsonDecode(response.body);
    } catch (e) {
      throw CatApiException("Ошибка сети: $e");
    }
  }

  Future<Cat> getImageInfo(String id) async {
    final json = await _get("/images/$id");
    return Cat.fromJson(json as Map<String, dynamic>);
  }

  Future<Cat> getRandomCat() async {
    final json = await _get("/images/search") as List<dynamic>;

    if (json.isEmpty) {
      throw CatApiException("API вернул пустой список");
    }

    final data = json.first as Map<String, dynamic>;
    return Cat.fromJson(data);
  }

  Future<Cat> getRandomCatWithBreed() async {
    final json = await _get("/images/search") as List<dynamic>;

    if (json.isEmpty || json.first["id"] == null) {
      throw CatApiException("API вернул пустой список");
    }

    final id = json.first["id"] as String;
    return getImageInfo(id);
  }

  Future<List<Breed>> getBreeds() async {
    final json = await _get("/breeds") as List<dynamic>;

    return json.map((b) => Breed.fromJson(b as Map<String, dynamic>)).toList();
  }
}

class CatApiException implements Exception {
  final String message;
  CatApiException(this.message);

  @override
  String toString() => "CatApiException: $message";
}
