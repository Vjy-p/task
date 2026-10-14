import 'dart:convert';
import 'package:hive/hive.dart';

part 'notification_model.g.dart';

NotificationModel notificationModelFromJson(String str) =>
    NotificationModel.fromJson(json.decode(str));

String notificationModelToJson(NotificationModel data) =>
    json.encode(data.toJson());

@HiveType(typeId: 10)
class NotificationModel {
  @HiveField(0)
  String? id;
  @HiveField(1)
  int? type;
  @HiveField(2)
  String? title;
  @HiveField(3)
  String? text;
  @HiveField(4)
  DateTime? date;

  NotificationModel({this.id, this.type, this.title, this.date, this.text});

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        id: json["id"],
        type: json["type"],
        title: json["title"],
        text: json["text"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": type,
    "title": title,
    "text": text,
    "date": date?.toIso8601String(),
  };
}
