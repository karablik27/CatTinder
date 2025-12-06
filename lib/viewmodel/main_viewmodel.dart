import 'package:flutter/material.dart';

import '../models/cat.dart';
import '../service/catapi_service.dart';
import '../service/cat_name_service.dart';

class MainViewModel extends ChangeNotifier {
  final api = CatApiService();
  final nameApi = CatNameService();

  Cat? cat;
  bool loading = false;
  String? error;
  bool snackbarShown = false;

  int likes = 0;

  Future<void> loadCat() async {
    loading = true;
    error = null;
    snackbarShown = false;
    notifyListeners();

    try {
      final newCat = await api.getRandomCatWithBreed();
      final generated = await nameApi.generateCatName(newCat.url);

      cat = newCat.copyWith(generatedName: generated);
    } catch (e) {
      error = e.toString();
      cat = null;
    }

    loading = false;
    notifyListeners();
  }

  void like() async {
    likes++;
    await loadCat();
  }

  void dislike() async {
    await loadCat();
  }
}
