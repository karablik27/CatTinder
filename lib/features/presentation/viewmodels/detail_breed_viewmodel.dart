import 'package:flutter/material.dart';

import '../../domain/entities/breed_entity.dart';

class DetailBreedViewModel extends ChangeNotifier {
  final BreedEntity breed;
  String? error;

  DetailBreedViewModel(this.breed);

  void setError(String message) {
    error = message;
    notifyListeners();
  }

  void retry() {
    error = null;
    notifyListeners();
  }
}
