import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

final filterProvider = ChangeNotifierProvider((ref) => FilterProviderModel());

class FilterProviderModel extends ChangeNotifier {
  List _rolesFilter = [];

  List get rolesFilter => _rolesFilter;


  void getFilter(value){
    _rolesFilter = value;
    notifyListeners();
  }

  void clearFilter(){
    _rolesFilter = [];
    notifyListeners();
  }


}
