import 'dart:convert';

import 'package:borecord/models/user_model.dart';
import 'package:borecord/utility/my_constant.dart';
import 'package:borecord/utility/my_dialog.dart';
import 'package:borecord/widgets/show_image.dart';
import 'package:borecord/widgets/show_title.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Authen extends StatefulWidget {
  const Authen({Key? key}) : super(key: key);

  @override
  _AuthenState createState() => _AuthenState();
}

class _AuthenState extends State<Authen> {
  bool redEye = true;
  final formKey = GlobalKey<FormState>();
  TextEditingController userController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  FlutterLocalNotificationsPlugin flutterLocalNotificationPlugin =
      FlutterLocalNotificationsPlugin();

  AndroidInitializationSettings? androidInitializationSettings;

  IOSInitializationSettings? iosInitializationSettings;

  InitializationSettings? initializationSettings;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializing();
  }

  Future<Null> initializing() async {
    androidInitializationSettings = AndroidInitializationSettings('noti2');
    iosInitializationSettings = IOSInitializationSettings(
      onDidReceiveLocalNotification: (id, title, body, payload) =>
          onDisReceiveLocalNotification(id, 'title', body, payload),
    );
    initializationSettings =
        InitializationSettings(android: androidInitializationSettings);
    await flutterLocalNotificationPlugin.initialize(initializationSettings!);
  }

  Future onSelectNotification(String? payLoad) async {
    if (payLoad != null) {
      print('onSelectNotification Workd payload ==> $payLoad');
    }
  }

  Future<dynamic> onDisReceiveLocalNotification(
      int id, String title, String? body, String? payload) async {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(body!),
      actions: [
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: () => print('CupertioAction OK'),
          child: Text('OK'),
        )
      ],
    );
  }

  Future<Null> processNotification() async {
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'idAndroid',
      'channelName',
      'channelDescription',
      priority: Priority.high,
      importance: Importance.max,
    );

    NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationPlugin.show(0, 'Notification มาสเตอร์',
        'ทดสอบ โดย มาสเตอร์ อึ่ง', notificationDetails);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) => GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          behavior: HitTestBehavior.opaque,
          child: SingleChildScrollView(
            child: Center(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildImage(constraints),
                    buildAppName(),
                    buildUser(constraints),
                    buildPassword(constraints),
                    buildLogin(constraints),
                    TextButton(
                        onPressed: () => processNotification(),
                        child: Text('Local Notification'))
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container buildLogin(BoxConstraints constraints) {
    return Container(
      margin: EdgeInsets.only(top: 16),
      width: constraints.maxWidth * 0.6,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(primary: MyConstant.primary),
        onPressed: () {
          if (formKey.currentState!.validate()) {
            checkAuthen();
          }
        },
        child: Text('Login'),
      ),
    );
  }

  Future<Null> checkAuthen() async {
    String user = userController.text;
    String password = passwordController.text;
    print('user = $user, password = $password');

    String apiCheckAuthen =
        '${MyConstant.domain}/borecord/getUserWhereUser.php?isAdd=true&user=$user';

    await Dio().get(apiCheckAuthen).then((value) async {
      print('value ==>> $value');
      if (value.toString() == 'null') {
        MyDialog()
            .normalDialog(context, 'User False', 'No $user in my database');
      } else {
        var result = json.decode(value.data);
        print('result ==> $result');

        for (var item in result) {
          UserModel model = UserModel.fromMap(item);
          if (password == model.password) {
            List<String> data = [];
            data.add(model.id);
            data.add(model.name);
            data.add(model.user);
            SharedPreferences preferences =
                await SharedPreferences.getInstance();
            preferences.setStringList('data', data);

            Navigator.pushNamedAndRemoveUntil(
                context, MyConstant.routeServiceApp, (route) => false);
          } else {
            MyDialog()
                .normalDialog(context, 'Password False', 'Please Try Again');
          }
        }
      }
    });
  }

  Container buildUser(BoxConstraints constraints) {
    return Container(
      margin: EdgeInsets.only(top: 16),
      width: constraints.maxWidth * 0.6,
      child: TextFormField(
        controller: userController,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please Fill User in Blank';
          } else {
            return null;
          }
        },
        decoration: InputDecoration(
          labelText: 'User :',
          prefixIcon: Icon(Icons.perm_identity),
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Container buildPassword(BoxConstraints constraints) {
    return Container(
      margin: EdgeInsets.only(top: 16),
      width: constraints.maxWidth * 0.6,
      child: TextFormField(
        controller: passwordController,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please Fill Password in Blank';
          } else {
            return null;
          }
        },
        obscureText: redEye,
        decoration: InputDecoration(
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                redEye = !redEye;
              });
            },
            icon: Icon(Icons.remove_red_eye),
          ),
          labelText: 'Password :',
          prefixIcon: Icon(Icons.lock_outline),
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  ShowTitle buildAppName() =>
      ShowTitle(title: MyConstant.appName, textStyle: MyConstant().h1Style());

  Container buildImage(BoxConstraints constraints) {
    return Container(
      width: constraints.maxWidth * 0.75,
      child: ShowImage(path: MyConstant.image3),
    );
  }
}
