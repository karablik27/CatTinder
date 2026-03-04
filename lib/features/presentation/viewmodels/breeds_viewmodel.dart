import 'package:flutter/material.dart';

import '../../domain/entities/breed_entity.dart';
import '../../domain/usecases/get_breeds_usecase.dart';

class BreedsViewModel extends ChangeNotifier {
  final GetBreedsUseCase getBreeds;

  BreedsViewModel({required this.getBreeds});

  List<BreedEntity> breeds = [];
  List<BreedEntity> filteredBreeds = [];
  bool loading = false;
  String? error;
  String searchQuery = '';

  Future<void> loadBreeds() async {
    loading = true;
    error = null;
    notifyListeners();

    try {
      breeds = await getBreeds();
      filteredBreeds = List.from(breeds);
    } catch (e) {
      error = e.toString();
      breeds = [];
      filteredBreeds = [];
    }

    loading = false;
    notifyListeners();
  }

  void updateSearch(String value) {
    searchQuery = value.toLowerCase();

    if (searchQuery.isEmpty) {
      filteredBreeds = List.from(breeds);
    } else {
      filteredBreeds = breeds.where((breed) {
        final name = breed.name.toLowerCase();
        final origin = breed.origin.toLowerCase();
        return _fuzzyScore(name, searchQuery) > 60 ||
            _fuzzyScore(origin, searchQuery) > 60;
      }).toList();
    }

    notifyListeners();
  }

  int _fuzzyScore(String text, String query) {
    if (text.contains(query)) {
      return 100;
    }

    var score = 0;
    var queryIndex = 0;

    for (var i = 0; i < text.length && queryIndex < query.length; i++) {
      if (text[i] == query[queryIndex]) {
        score += 15;
        queryIndex++;
      } else if (text.contains(query)) {
        score += 5;
      }
    }

    return score.clamp(0, 100);
  }
}
