import 'package:borecord/utility/my_constant.dart';
import 'package:borecord/widgets/show_image.dart';
import 'package:borecord/widgets/show_title.dart';
import 'package:flutter/material.dart';

class MyDialog {
  Future<Null> normalDialog(
      BuildContext context, String title, String message) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: ListTile(
          leading: ShowImage(path: MyConstant.image1),
          title: ShowTitle(title: title, textStyle: MyConstant().h2Style()),
          subtitle: ShowTitle(title: message, textStyle: MyConstant().h3Style()),
        ),actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text('OK'))],
      ),
    );
  }
}
