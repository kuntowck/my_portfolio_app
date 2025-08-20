import 'package:flutter/material.dart';
import 'package:my_portfolio_app/models/portfolio_model.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class PortfolioProvider with ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  final picker = ImagePicker();

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final categoryController = TextEditingController();
  final linkController = TextEditingController();

  List<String> stack = [];
  File? image;
  DateTime? completionDate;

  Portfolio get portfolio => Portfolio(
    title: titleController.text,
    description: descriptionController.text,
    category: categoryController.text,
    stack: stack,
    image: image!,
    completionDate: completionDate,
    link: linkController.text.isEmpty ? null : linkController.text,
  );

  void setStack(List<String> newStack) {
    stack = newStack;
    notifyListeners();
  }

  void setImage(File? image) {
    if (image != null) {
      portfolio.image = image;
    }
    notifyListeners();
  }

  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setImage(File(pickedFile.path));
    }
  }

  void setCompletionDate(DateTime date) {
    completionDate = date;
    notifyListeners();
  }

  Future<void> pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: portfolio.completionDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setCompletionDate(picked);
    }
  }

  bool validateForm() {
    return formKey.currentState!.validate();
  }

  void reset() {
    titleController.clear();
    descriptionController.clear();
    categoryController.clear();
    linkController.clear();
    stack = [];
    image = null;
    completionDate = null;
    notifyListeners();
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    categoryController.dispose();
    linkController.dispose();
    super.dispose();
  }
}
