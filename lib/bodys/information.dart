import 'package:borecord/utility/my_constant.dart';
import 'package:borecord/widgets/show_title.dart';
import 'package:flutter/material.dart';

class Information extends StatefulWidget {
  const Information({ Key? key }) : super(key: key);

  @override
  _InformationState createState() => _InformationState();
}

class _InformationState extends State<Information> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: ShowTitle(title: 'Information', textStyle: MyConstant().h1Style())),
    );
  }
}