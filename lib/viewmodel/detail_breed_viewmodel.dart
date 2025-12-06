import 'package:flutter/material.dart';
import '../models/breed.dart';

class DetailBreedViewModel extends ChangeNotifier {
  final Breed breed;

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
