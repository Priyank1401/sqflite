class DbFields {
  static const List<String> values = [
    id,
    date,
    month,
    title,
    quantity,
    price,
  ];

  static const String tableName = 'task';

  static const String idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
  static const String textType = 'TEXT NOT NULL';
  static const String realType = 'REAL NOT NULL';

  static const String id = '_id';
  static const String date = 'date';
  static const String month = 'month';
  static const String title = 'title';
  static const String quantity = 'quantity';
  static const String price = 'price';

}