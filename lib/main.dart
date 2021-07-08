import 'dart:math';

import 'package:borecord/states/add_data.dart';
import 'package:borecord/states/authen.dart';
import 'package:borecord/states/service_add.dart';
import 'package:borecord/utility/my_constant.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

final Map<String, WidgetBuilder> map = {
  '/authen': (BuildContext context) => Authen(),
  '/serviceApp': (BuildContext context) => ServiceApp(),
  
};

String? firstState;

Future<Null> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  List<String>? data = preferences.getStringList('data');
  print('## data ==>> $data');
  if (data == null) {
    firstState = MyConstant.routeAuthen;
    runApp(MyApp());
  } else {
    firstState = MyConstant.routeServiceApp;
    runApp(MyApp());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: MyConstant.appName,
      routes: map,
      initialRoute: firstState,
    );
  }
}
