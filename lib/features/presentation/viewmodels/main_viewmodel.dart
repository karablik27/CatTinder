import 'package:flutter/material.dart';

import '../../domain/entities/cat_entity.dart';
import '../../domain/usecases/get_random_cat_with_generated_name_usecase.dart';

class MainViewModel extends ChangeNotifier {
  final GetRandomCatWithGeneratedNameUseCase getRandomCatWithGeneratedName;

  MainViewModel({required this.getRandomCatWithGeneratedName});

  CatEntity? cat;
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
      cat = await getRandomCatWithGeneratedName();
    } catch (e) {
      error = e.toString();
      cat = null;
    }

    loading = false;
    notifyListeners();
  }

  Future<void> like() async {
    likes++;
    await loadCat();
  }

  Future<void> dislike() async {
    await loadCat();
  }
}
