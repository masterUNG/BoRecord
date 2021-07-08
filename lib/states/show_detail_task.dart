import 'package:borecord/models/task_model.dart';
import 'package:borecord/utility/my_constant.dart';
import 'package:borecord/widgets/show_title.dart';
import 'package:flutter/material.dart';

class ShowDetailTask extends StatefulWidget {
  final TaskModel taskModel;
  const ShowDetailTask({Key? key, required this.taskModel}) : super(key: key);

  @override
  _ShowDetailTaskState createState() => _ShowDetailTaskState();
}

class _ShowDetailTaskState extends State<ShowDetailTask> {
  TaskModel? taskModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    taskModel = widget.taskModel;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Show Detail Task'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) => GestureDetector(
          child: Column(
            children: [
              buildHeadTitle(),
              buildListImage(convertStringToArray(taskModel!.images)),
            ],
          ),
        ),
      ),
    );
  }

  List<String> convertStringToArray(String string) {
    String result = string.substring(1, string.length - 1);
    List<String> strings = result.split(',');
    int index = 0;
    for (var item in strings) {
      strings[index] = item.trim();
      index++;
    }
    return strings;
  }

  Widget buildListImage(List<String> strings) => ListView.builder(
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemCount: strings.length,
        itemBuilder: (context, index) => Column(
          children: [
            Container(
              width: 200,
              height: 200,
              child: Image.network(
                  '${MyConstant.domain}/borecord${strings[index]}'),
            ),
            Text(strings[index]),
          ],
        ),
      );

  ShowTitle buildHeadTitle() {
    return ShowTitle(
        title: taskModel!.taskName, textStyle: MyConstant().h1Style());
  }
}
