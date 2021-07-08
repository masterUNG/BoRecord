import 'dart:async';
import 'dart:convert';

import 'package:borecord/models/task_model.dart';
import 'package:borecord/utility/my_constant.dart';
import 'package:borecord/widgets/show_progress.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class SearchTask extends StatefulWidget {
  const SearchTask({Key? key}) : super(key: key);

  @override
  _SearchTaskState createState() => _SearchTaskState();
}

class _SearchTaskState extends State<SearchTask> {
  List<TaskModel> taskModels = [];
  List<TaskModel> searchTaskModels = [];
  final debouncer = Debouncer(millisecond: 500);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readAllTask();
  }

  Future<Null> readAllTask() async {
    String apiReadAllTask = '${MyConstant.domain}/borecord/getAllTask.php';
    await Dio().get(apiReadAllTask).then((value) {
      // print('## value ==>> $value');
      for (var item in json.decode(value.data)) {
        TaskModel model = TaskModel.fromMap(item);
        setState(() {
          taskModels.add(model);
          searchTaskModels = taskModels;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: taskModels.length == 0
          ? ShowProgress()
          : Column(
              children: [
                buildSearch(),
                buildListResult(),
              ],
            ),
    );
  }

  Padding buildSearch() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextFormField(
        onChanged: (value) {
          debouncer.run(() {
            setState(() {
              searchTaskModels = taskModels
                  .where((element) => element.taskName
                      .toLowerCase()
                      .contains(value.toLowerCase()))
                  .toList();
            });
          });
        },
        decoration: InputDecoration(
          hintText: 'Search',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget buildListResult() => Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          shrinkWrap: true,
          physics: ScrollPhysics(),
          itemCount: searchTaskModels.length,
          itemBuilder: (context, index) =>
              Text(searchTaskModels[index].taskName),
        ),
      );
}

class Debouncer {
  final int millisecond;
   Timer? timer;
   VoidCallback? callback;

  Debouncer({required this.millisecond});

  run(VoidCallback callback) {
    if (null != timer) {
      timer!.cancel();
    }
    timer = Timer(Duration(milliseconds: millisecond), callback);
  }
}
