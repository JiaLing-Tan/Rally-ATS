import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rally/model/request.dart';
import 'package:http/http.dart' as http;

import '../../resources/utils.dart';


final requestProvider = ChangeNotifierProvider((ref) => RequestProviderModal());

class RequestProviderModal extends ChangeNotifier {
  Request _request = Request.empty();
  bool _isLoading = false;

  Request get request => _request;
  bool get isLoading => _isLoading;

  void setRequest(request){
    _request = request;
    notifyListeners();
  }

  void setLoading(isLoading){
    _isLoading = isLoading;
    notifyListeners();
  }

  Stream<List<Request>> getRequest() async* {
    print("getting data");
    final response =
    await http.get(Uri.parse("$url?token=$token&funcName=getRequest"));
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      List<Request> requests = jsonData.map((request) {
        return Request.fromJson(request);
      }).toList();
      yield requests;
    } else {
      throw Exception('Failed to fetch requests');
    }

    if (_isLoading) {
        _isLoading = false;
        notifyListeners();
    }
  }


}
