import 'dart:convert';
import 'package:hive/hive.dart';

part 'category_model.g.dart';

List<CategoryModel> categoryModelFromJson(String str) =>
    List<CategoryModel>.from(
      json.decode(str).map((x) => CategoryModel.fromJson(x)),
    );

String categoryModelToJson(List<CategoryModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@HiveType(typeId: 7)
class CategoryModel {
  @HiveField(0)
  String? slug;
  @HiveField(1)
  String? name;
  @HiveField(2)
  String? url;

  CategoryModel({this.slug, this.name, this.url});

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      CategoryModel(slug: json["slug"], name: json["name"], url: json["url"]);

  Map<String, dynamic> toJson() => {"slug": slug, "name": name, "url": url};
}
