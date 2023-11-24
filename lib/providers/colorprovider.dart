import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ColorProvider with ChangeNotifier {
  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;
  //
  //bool value
  //
  bool _isSelected = true;
  bool get isSelected => _isSelected;

  void setIndex(int index) {
    _selectedIndex = index;
    //true
    _isSelected = true;
    notifyListeners();
  }

  void setindextoZero() {
    _selectedIndex = 0;
    notifyListeners();
  }

  void isSelectedFalse() {
    _isSelected = false;
    notifyListeners();
  }

  void iskkk(int clrindex) {
    _selectedIndex = clrindex;
  }

  // void selectedBorder(int index) {
  //   _isSelected = index == selectedIndex;
  //   print(_isSelected);
  //   notifyListeners();
  // }
}
