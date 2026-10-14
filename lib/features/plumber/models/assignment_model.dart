import 'package:assessment/features/products/models/product_model.dart';

class AssignmentModel {
  String id;
  String? title;
  String? code;
  String? customerName;
  String? customerNumber;
  String? schedule;
  String? address;
  String? date;
  String? time;
  String? status;
  String? description;
  List<ProductModel> products;

  AssignmentModel({
    required this.id,
    this.title,
    this.code,
    this.customerName,
    this.customerNumber,
    this.address,
    this.schedule,
    this.date,
    this.time,
    this.status,
    this.description,
    required this.products,
  });
}
