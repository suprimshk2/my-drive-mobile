import 'package:flutter/material.dart';

class GlobalViewModal extends ChangeNotifier {

  // private variable.
  int _randInt = 0;

  // setter example
  void setInteger(int value) {
    _randInt = value;
    notifyListeners();
  }

  // getter example
  int get randInt => _randInt;
}
