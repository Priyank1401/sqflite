import 'package:sqlite/db/db_fields.dart';

class TaskModel {
  final int? id;
  final String? date;
  final String? month;
  final String title;
  final String quantity;
  final double price;

  TaskModel({
    this.id,
    required this.date,
    required this.month,
    required this.title,
    required this.quantity,
    required this.price
  });

  factory TaskModel.fromJson(Map<String, Object?> json) => TaskModel(
    id: json[DbFields.id] as int?,
    date: json[DbFields.date] as String,
    month: json[DbFields.month] as String,
    title: json[DbFields.title] as String,
    quantity: json[DbFields.quantity] as String,
    price: json[DbFields.price] as double,
  );

  Map<String, Object?> toJson() => {
    DbFields.id: id,
    DbFields.date: date,
    DbFields.month: month,
    DbFields.title: title,
    DbFields.quantity: quantity,
    DbFields.price: price,
  };

  TaskModel copy({
    int? id,
    String? date,
    String? month,
    String? title,
    String? quantity,
    double? price
  }) =>
      TaskModel(
        id: id ?? this.id,
        date: date ?? this.date,
        month: month ?? this.month,
        title: title ?? this.title,
        quantity: quantity ?? this.quantity,
        price: price ?? this.price,
      );
}