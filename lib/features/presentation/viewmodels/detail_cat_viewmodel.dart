import 'package:flutter/material.dart';

import '../../domain/entities/cat_entity.dart';

class DetailCatViewModel extends ChangeNotifier {
  final CatEntity cat;
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
