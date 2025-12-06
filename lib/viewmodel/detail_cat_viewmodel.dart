import 'package:flutter/material.dart';
import '../models/cat.dart';

class DetailCatViewModel extends ChangeNotifier {
  final Cat cat;

  String? error;

  DetailCatViewModel(this.cat);

  void setError(String message) {
    error = message;
    notifyListeners();
  }

  void retry() {
    error = null;
    notifyListeners();
  }
}
