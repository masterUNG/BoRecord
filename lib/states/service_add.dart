import 'dart:convert';

import 'package:borecord/bodys/information.dart';
import 'package:borecord/bodys/list_task.dart';
import 'package:borecord/bodys/search_task.dart';
import 'package:borecord/models/user_model.dart';
import 'package:borecord/utility/my_constant.dart';
import 'package:borecord/widgets/show_image.dart';
import 'package:borecord/widgets/show_title.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ServiceApp extends StatefulWidget {
  const ServiceApp({Key? key}) : super(key: key);

  @override
  _ServiceAppState createState() => _ServiceAppState();
}

class _ServiceAppState extends State<ServiceApp> {
  String? nameLogin, nameLoginOnHeader;
  List<Widget> widgets = [
    ListTask(),
    Information(),
    SearchTask(),
  ];
  int indexWidget = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    findData();
  }

  Future<Null> findData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    List<String>? data = preferences.getStringList('data');

    String apiCheckAuthen =
        '${MyConstant.domain}/borecord/getUserWhereUser.php?isAdd=true&user=${data![2]}';

    await Dio().get(apiCheckAuthen).then((value) {
      for (var item in json.decode(value.data)) {
        UserModel model = UserModel.fromMap(item);
        setState(() {
          nameLogin = data[1];
          nameLoginOnHeader = model.name;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: MyConstant.primary,
          title: Text('Service App'),
        ),
        drawer: Drawer(
          child: Stack(
            children: [
              buildSignOut(),
              Column(
                children: [
                  // buildHeader(),
                  drawerHeader(),
                  menuListTask(),
                  menuInformaiton(),
                  menuInSearchTask(),
                ],
              ),
            ],
          ),
        ),
        body: widgets[indexWidget]);
  }

  ListTile menuListTask() {
    return ListTile(
      onTap: () {
        setState(() {
          indexWidget = 0;
        });
        Navigator.pop(context);
      },
      leading: Icon(
        Icons.home,
        color: MyConstant.dark,
      ),
      title: ShowTitle(title: 'List Task', textStyle: MyConstant().h2Style()),
    );
  }

  ListTile menuInformaiton() {
    return ListTile(
      onTap: () {
        setState(() {
          indexWidget = 1;
        });
        Navigator.pop(context);
      },
      leading: Icon(
        Icons.info,
        color: MyConstant.dark,
      ),
      title: ShowTitle(title: 'Information', textStyle: MyConstant().h2Style()),
    );
  }

  ListTile menuInSearchTask() {
    return ListTile(
      onTap: () {
        setState(() {
          indexWidget = 2;
        });
        Navigator.pop(context);
      },
      leading: Icon(
        Icons.search,
        color: MyConstant.dark,
      ),
      title: ShowTitle(title: 'Search Task', textStyle: MyConstant().h2Style()),
    );
  }

  UserAccountsDrawerHeader buildHeader() {
    return UserAccountsDrawerHeader(
      decoration: BoxDecoration(color: MyConstant.primary),
      accountName: nameLogin == null ? Text('') : Text(nameLogin!),
      accountEmail: Text('Login'),
      currentAccountPicture: ShowImage(path: MyConstant.image3),
    );
  }

  DrawerHeader drawerHeader() => DrawerHeader(
          child: Column(
        children: [
          Container(
            width: 100,
            height: 100,
            child: ShowImage(path: MyConstant.image1),
          ),
          Text('Name => $nameLoginOnHeader'),
        ],
      ));

  Column buildSignOut() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ListTile(
          onTap: () async {
            SharedPreferences preferences =
                await SharedPreferences.getInstance();
            preferences.clear().then((value) =>
                Navigator.pushNamedAndRemoveUntil(
                    context, MyConstant.routeAuthen, (route) => false));
          },
          leading: Icon(
            Icons.exit_to_app,
            size: 36,
            color: MyConstant.dark,
          ),
          title: ShowTitle(title: 'SignOut', textStyle: MyConstant().h2Style()),
        ),
      ],
    );
  }
}
