import 'package:flutter/material.dart';
import 'package:my_portfolio_app/models/portfolio_model.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:my_portfolio_app/services/portfolio_service.dart';

class PortfolioProvider with ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  final picker = ImagePicker();
  final PortfolioService _service = PortfolioService();
  final List<String> _categories = [
    "Web Development",
    "Mobile App",
    "UI Design",
  ];

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final stackController = TextEditingController();
  final linkController = TextEditingController();

  List<Portfolio> _portfolios = [];
  String? category;
  List<String> stack = [];
  File? image;
  DateTime? completionDate;
  String? _errorMessage;
  bool _isLoading = false;

  List<String> get categories => _categories;
  List<Portfolio> get portfolios => _portfolios;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;

  Future<void> loadPortfolios() async {
    _errorMessage = null;
    _isLoading = true;
    notifyListeners();

    try {
      _portfolios = await _service.fetchPortfolios();

      await Future.delayed(Duration(seconds: 1));
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addPortfolio() async {
    final title = titleController.text;
    final description = descriptionController.text;
    final selectedCategory = category!;
    final selectedStack = stack;
    final selectedCompletionDate = completionDate;
    final projectLink = linkController.text.isEmpty
        ? null
        : linkController.text;

    _errorMessage = null;
    _isLoading = true;
    notifyListeners();

    try {
      final imageUrl = await _service.uploadImage(image!);

      final Portfolio portfolio = Portfolio(
        title: title,
        description: description,
        category: selectedCategory,
        stack: selectedStack,
        imageUrl: imageUrl,
        completionDate: selectedCompletionDate!,
        projectLink: projectLink,
      );

      final newPortfolio = await _service.addPortfolio(portfolio);

      _portfolios.add(newPortfolio);

      loadPortfolios();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

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
