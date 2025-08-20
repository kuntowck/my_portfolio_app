import 'dart:io';

class Portfolio {
  String title;
  String description;
  String category;
  List stack;
  File image;
  DateTime? completionDate;
  String? link;

  Portfolio({
    required this.title,
    required this.description,
    required this.category,
    required this.stack,
    required this.image,
    this.completionDate,
    this.link,
  });
}
