import 'dart:convert';

import 'package:borecord/models/task_model.dart';
import 'package:borecord/states/add_data.dart';
import 'package:borecord/states/show_detail_task.dart';
import 'package:borecord/utility/my_constant.dart';
import 'package:borecord/widgets/show_progress.dart';
import 'package:borecord/widgets/show_title.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListTask extends StatefulWidget {
  const ListTask({Key? key}) : super(key: key);

  @override
  _ListTaskState createState() => _ListTaskState();
}

class _ListTaskState extends State<ListTask> {
  List<TaskModel> taskModels = [];
  bool load = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readTaskFromServer();
  }

  Future<Null> readTaskFromServer() async {
    if (taskModels.length != 0) {
      taskModels.clear();
    }

    SharedPreferences preferences = await SharedPreferences.getInstance();
    List<String>? data = preferences.getStringList('data');
    String idOfficer = data![0];
    String apiTask =
        '${MyConstant.domain}/borecord/getTaskWhereIdOfficer.php?isAdd=true&idOfficer=$idOfficer';
    await Dio().get(apiTask).then((value) {
      // print('## value ==>> $value');
      load = false;
      for (var item in json.decode(value.data)) {
        TaskModel model = TaskModel.fromMap(item);
        setState(() {
          taskModels.add(model);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: load
          ? ShowProgress()
          : LayoutBuilder(
              builder: (context, constraints) => buildListView(constraints),
            ),
    );
  }

  ListView buildListView(BoxConstraints constraints) {
    return ListView.builder(
      itemCount: taskModels.length,
      itemBuilder: (context, index) => InkWell(
        onTap: () {
          if (taskModels[index].status == 'true') {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ShowDetailTask(taskModel: taskModels[index],),
                ));
          } else {
            routeToAddData(context, index);
          }
        },
        child: Card(
          color: index % 2 == 0 ? Colors.grey.shade300 : Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: constraints.maxWidth * 0.5,
                      child: ShowTitle(
                          title: taskModels[index].taskName,
                          textStyle: MyConstant().h1Style()),
                    ),
                    Checkbox(
                      value: checkStatus(taskModels[index].status),
                      onChanged: (value) {},
                    )
                  ],
                ),
                ShowTitle(
                    title: cutWord(taskModels[index].detail),
                    textStyle: MyConstant().h3Style())
              ],
            ),
          ),
        ),
      ),
    );
  }

  void routeToAddData(BuildContext context, int index) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddData(
            taskModel: taskModels[index],
          ),
        )).then((value) => readTaskFromServer());
  }

  bool checkStatus(String string) {
    if (string == 'true') {
      return true;
    } else {
      return false;
    }
  }

  String cutWord(String string) {
    if (string.length > 80) {
      String result = string.substring(0, 80);
      result = '$result ...';
      return result;
    } else {
      return string;
    }
  }
}
