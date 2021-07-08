import 'dart:convert';

class TaskModel {
  final String id;
  final String idOfficer;
  final String taskName;
  final String detail;
  final String editDataTime;
  final String images;
  final String myrequire;
  final String detailRequire;
  final String gender;
  final String status;
  TaskModel({
    required this.id,
    required this.idOfficer,
    required this.taskName,
    required this.detail,
    required this.editDataTime,
    required this.images,
    required this.myrequire,
    required this.detailRequire,
    required this.gender,
    required this.status,
  });

  TaskModel copyWith({
    String? id,
    String? idOfficer,
    String? taskName,
    String? detail,
    String? editDataTime,
    String? images,
    String? myrequire,
    String? detailRequire,
    String? gender,
    String? status,
  }) {
    return TaskModel(
      id: id ?? this.id,
      idOfficer: idOfficer ?? this.idOfficer,
      taskName: taskName ?? this.taskName,
      detail: detail ?? this.detail,
      editDataTime: editDataTime ?? this.editDataTime,
      images: images ?? this.images,
      myrequire: myrequire ?? this.myrequire,
      detailRequire: detailRequire ?? this.detailRequire,
      gender: gender ?? this.gender,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idOfficer': idOfficer,
      'taskName': taskName,
      'detail': detail,
      'editDataTime': editDataTime,
      'images': images,
      'myrequire': myrequire,
      'detailRequire': detailRequire,
      'gender': gender,
      'status': status,
    };
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'],
      idOfficer: map['idOfficer'],
      taskName: map['taskName'],
      detail: map['detail'],
      editDataTime: map['editDataTime'],
      images: map['images'],
      myrequire: map['myrequire'],
      detailRequire: map['detailRequire'],
      gender: map['gender'],
      status: map['status'],
    );
  }

  String toJson() => json.encode(toMap());

  factory TaskModel.fromJson(String source) => TaskModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'TaskModel(id: $id, idOfficer: $idOfficer, taskName: $taskName, detail: $detail, editDataTime: $editDataTime, images: $images, myrequire: $myrequire, detailRequire: $detailRequire, gender: $gender, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is TaskModel &&
      other.id == id &&
      other.idOfficer == idOfficer &&
      other.taskName == taskName &&
      other.detail == detail &&
      other.editDataTime == editDataTime &&
      other.images == images &&
      other.myrequire == myrequire &&
      other.detailRequire == detailRequire &&
      other.gender == gender &&
      other.status == status;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      idOfficer.hashCode ^
      taskName.hashCode ^
      detail.hashCode ^
      editDataTime.hashCode ^
      images.hashCode ^
      myrequire.hashCode ^
      detailRequire.hashCode ^
      gender.hashCode ^
      status.hashCode;
  }
}
