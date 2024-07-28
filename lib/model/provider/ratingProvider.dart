import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

final ratingProvider = ChangeNotifierProvider((ref) => RatingProviderModal());

class RatingProviderModal extends ChangeNotifier {

  RangeValues _currentRating = RangeValues(0, 100);
  List _rolesFilter = [];

  RangeValues get currentRating => _currentRating;
  List get rolesFilter => _rolesFilter;

  void updateRating(value){
    _currentRating = value;
    notifyListeners();
  }

  void addRoles(value) {
    _rolesFilter.add(value);
    notifyListeners();
  }

  void removeRoles(value) {
    _rolesFilter.remove(value);
    notifyListeners();
  }

  void clear(){
    _rolesFilter = [];
    _currentRating = RangeValues(0, 100);
    notifyListeners();
  }


}
