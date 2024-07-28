import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rally/model/request.dart';


final requestProvider = ChangeNotifierProvider((ref) => RequestProviderModal());

class RequestProviderModal extends ChangeNotifier {
  Request _request = Request.empty();

  Request get request => _request;

  void setRequest(request){
    _request = request;
    notifyListeners();
  }


}
