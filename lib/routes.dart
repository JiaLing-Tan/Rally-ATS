import 'package:flutter/material.dart';
import 'package:rally/screen/dashboard.dart';

class Routes {
  Routes._();

  static const String dashboard = '/dashboard';

  static final dynamic routes = <String, WidgetBuilder>{
    dashboard: (BuildContext context) => const Dashboard(),
  };
}