import 'dart:io';
import 'dart:math';

import 'package:borecord/models/task_model.dart';
import 'package:borecord/utility/my_constant.dart';
import 'package:borecord/utility/my_dialog.dart';
import 'package:borecord/widgets/show_image.dart';
import 'package:borecord/widgets/show_title.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddData extends StatefulWidget {
  final TaskModel taskModel;

  const AddData({Key? key, required this.taskModel}) : super(key: key);

  @override
  _AddDataState createState() => _AddDataState();
}

class _AddDataState extends State<AddData> {
  TaskModel? taskModel;
  String? gendle;
  File? file;
  List<File?> files = [];
  final formKey = GlobalKey<FormState>();
  TextEditingController requireController = TextEditingController();
  TextEditingController detailRequireController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    taskModel = widget.taskModel;
    initialFiles();
  }

  void initialFiles() {
    for (var i = 0; i < 3; i++) {
      files.add(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () => processUploadAnInsertData(),
              icon: Icon(Icons.cloud_upload))
        ],
        backgroundColor: MyConstant.primary,
        title: Text(taskModel!.taskName),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) => GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          behavior: HitTestBehavior.opaque,
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildTitle(constraints),
                  buildDetail(),
                  buildShowImage(constraints),
                  buildControlImage(constraints),
                  buildRequire(constraints),
                  buildRequireDetail(constraints),
                  buildTitleGendel(),
                  groupRadio(constraints),
                  buildAddDataButton(constraints),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container buildAddDataButton(BoxConstraints constraints) {
    return Container(
      width: constraints.maxWidth,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(primary: MyConstant.primary),
        onPressed: () => processUploadAnInsertData(),
        child: Text('Add Data'),
      ),
    );
  }

  Future<Null> processUploadAnInsertData() async {
    DateTime dateTime = DateTime.now();

    bool statusImage = true; //true => Choose Image Success
    for (var item in files) {
      if (item == null) {
        statusImage = false;
      }
    }

    if (statusImage) {
      print('## Choose Image Success');
      if (formKey.currentState!.validate()) {
        if (gendle == null) {
          MyDialog()
              .normalDialog(context, 'No Gendle', 'Pleaset Choose Gendle');
        } else {
          print('### every thing OK');
          List<String> images = [];

          for (var item in files) {
            int i = Random().nextInt(100000);
            String nameImage = 'task$i.jpg';
            images.add('/task/$nameImage');
            Map<String, dynamic> map = {};
            map['file'] =
                await MultipartFile.fromFile(item!.path, filename: nameImage);
            FormData formData = FormData.fromMap(map);
            String apiSaveTask = '${MyConstant.domain}/borecord/saveTask.php';
            await Dio()
                .post(apiSaveTask, data: formData)
                .then((value) => print('## Upload Image Success'));
          }

          print('### images ==>> $images, dateTime ==> ${dateTime.toString()}');
          String apiEditData =
              '${MyConstant.domain}/borecord/editTaskWhereId.php?isAdd=true&id=${taskModel!.id}&editDataTime=${dateTime.toString()}&images=${images.toString()}&myrequire=${requireController.text}&detailRequire=${detailRequireController.text}&gender=$gendle';
          await Dio().get(apiEditData).then((value) => Navigator.pop(context));
        }
      }
    } else {
      MyDialog().normalDialog(
          context, 'Uncompleate Image ?', 'Please Choose 3 Image');
    }
  }

  Row groupRadio(BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: constraints.maxWidth * 0.6,
          child: Column(
            children: [
              buildMale(),
              buildFeMale(),
            ],
          ),
        ),
      ],
    );
  }

  RadioListTile<String> buildMale() {
    return RadioListTile(
      title: ShowTitle(title: 'Male', textStyle: MyConstant().h3Style()),
      value: 'male',
      groupValue: gendle,
      onChanged: (value) {
        setState(() {
          gendle = value as String?;
        });
      },
    );
  }

  RadioListTile<String> buildFeMale() {
    return RadioListTile(
      title: ShowTitle(title: 'Female', textStyle: MyConstant().h3Style()),
      value: 'female',
      groupValue: gendle,
      onChanged: (value) {
        setState(() {
          gendle = value as String?;
        });
      },
    );
  }

  Padding buildTitleGendel() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ShowTitle(title: 'Gendle :', textStyle: MyConstant().h2Style()),
    );
  }

  Row buildRequire(BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 16),
          width: constraints.maxWidth * 0.6,
          child: TextFormField(controller: requireController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please Fill Requrie in Blank';
              } else {
                return null;
              }
            },
            decoration: InputDecoration(
              labelText: 'Require :',
              prefixIcon: Icon(Icons.request_quote_outlined),
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildRequireDetail(BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 16),
          width: constraints.maxWidth * 0.6,
          child: TextFormField(controller: detailRequireController,
            maxLines: 4,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please Fill Requrie in Blank';
              } else {
                return null;
              }
            },
            decoration: InputDecoration(
              hintText: 'Require Detail :',
              prefixIcon: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 60),
                child: Icon(Icons.details),
              ),
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }

  Future<Null> confirmSoureImage(int index) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: ListTile(
          leading: ShowImage(path: MyConstant.image1),
          title: ShowTitle(
              title: 'Choose Source Image ?',
              textStyle: MyConstant().h2Style()),
          subtitle: ShowTitle(
              title: 'Please Tap Camera or Gallery',
              textStyle: MyConstant().h3Style()),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              processCreateImage(ImageSource.camera, index);
            },
            child: Text('Camera'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              processCreateImage(ImageSource.gallery, index);
            },
            child: Text('Gallery'),
          ),
        ],
      ),
    );
  }

  Future<Null> processCreateImage(ImageSource source, int index) async {
    try {
      var result = await ImagePicker().getImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
      );
      setState(() {
        file = File(result!.path);
        files[index] = file;
      });
    } catch (e) {}
  }

  Widget buildControlImage(BoxConstraints constraints) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: constraints.maxWidth * 0.6,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: () => confirmSoureImage(0),
                  child: Container(
                    width: 48,
                    child: files[0] == null
                        ? ShowImage(path: MyConstant.image2)
                        : Image.file(files[0]!),
                  ),
                ),
                InkWell(
                  onTap: () => confirmSoureImage(1),
                  child: Container(
                    width: 48,
                    child: files[1] == null
                        ? ShowImage(path: MyConstant.image3)
                        : Image.file(files[1]!),
                  ),
                ),
                InkWell(
                  onTap: () => confirmSoureImage(2),
                  child: Container(
                    width: 48,
                    child: files[2] == null
                        ? ShowImage(path: MyConstant.image4)
                        : Image.file(files[2]!),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Row buildShowImage(BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: constraints.maxWidth * 0.6,
          width: constraints.maxWidth * 0.6,
          child: file == null
              ? ShowImage(path: MyConstant.image1)
              : Image.file(file!),
        ),
      ],
    );
  }

  Padding buildDetail() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ShowTitle(
          title: taskModel!.detail, textStyle: MyConstant().h3Style()),
    );
  }

  Container buildTitle(BoxConstraints constraints) {
    return Container(
      width: constraints.maxWidth * 0.75,
      child: ShowTitle(
          title: taskModel!.taskName, textStyle: MyConstant().h1Style()),
    );
  }
}
