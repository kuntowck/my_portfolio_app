import 'package:flutter/material.dart';
import 'package:my_portfolio_app/models/portfolio_model.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class PortfolioProvider with ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  final picker = ImagePicker();
  final List<Portfolio> _portfolios = [];

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final stackController = TextEditingController();
  final linkController = TextEditingController();

  String? category;
  List<String> stack = [];
  File? image;
  DateTime? completionDate;

  List<Portfolio> get portfolios => _portfolios;

  Portfolio get portfolio => Portfolio(
    title: titleController.text,
    description: descriptionController.text,
    category: category!,
    stack: stack,
    image: image!,
    completionDate: completionDate,
    link: linkController.text.isEmpty ? null : linkController.text,
  );

  void setStack(String value) {
    if (value.isNotEmpty && !stack.contains(value)) {
      stack.add(value);
      notifyListeners();
    }
  }

  void removeStack(String value) {
    stack.remove(value);
    notifyListeners();
  }

  void setCategory(String? value) {
    if (value != null) {
      category = value;
    }
    notifyListeners();
  }

  void setImage(File? value) {
    if (value != null) {
      image = value;
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
      initialDate: completionDate ?? DateTime.now(),
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

  void addPortfolio() {
    _portfolios.add(portfolio);
    notifyListeners();
  }

  void resetForm() {
    titleController.clear();
    descriptionController.clear();
    stackController.clear();
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
    stackController.dispose();
    linkController.dispose();
    super.dispose();
  }
}
