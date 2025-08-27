import 'package:flutter/material.dart';

class BottomBarViewModel extends ChangeNotifier {
  int _pageIndex = 2;

  setPageIndex(int value) {
    _pageIndex = value;
    notifyListeners();
  }

  get pageIndex => _pageIndex;
}
