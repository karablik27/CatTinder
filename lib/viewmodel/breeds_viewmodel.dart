import 'package:flutter/material.dart';

import '../models/breed.dart';
import '../service/catapi_service.dart';

class BreedsViewModel extends ChangeNotifier {
  final api = CatApiService();

  List<Breed> breeds = [];
  List<Breed> filteredBreeds = [];

  bool loading = false;
  String? error;

  String searchQuery = "";

  Future<void> loadBreeds() async {
    loading = true;
    error = null;
    notifyListeners();

    try {
      breeds = await api.getBreeds();
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
      filteredBreeds = breeds.where((b) {
        final name = b.name.toLowerCase();
        final origin = b.origin.toLowerCase();

        return _fuzzyScore(name, searchQuery) > 60 ||
            _fuzzyScore(origin, searchQuery) > 60;
      }).toList();
    }

    notifyListeners();
  }

  int _fuzzyScore(String text, String query) {
    if (text.contains(query)) return 100;

    int score = 0;
    int qi = 0;

    for (int i = 0; i < text.length && qi < query.length; i++) {
      if (text[i] == query[qi]) {
        score += 15;
        qi++;
      } else if (text.contains(query)) {
        score += 5;
      }
    }

    return score.clamp(0, 100);
  }
}
