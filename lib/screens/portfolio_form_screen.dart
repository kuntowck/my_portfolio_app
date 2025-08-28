import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_portfolio_app/widgets/stack_chip.dart';
import 'package:my_portfolio_app/widgets/custom_app_bar.dart';
import 'package:provider/provider.dart';
import '../providers/portfolio_provider.dart';

class PortfolioFormScreen extends StatelessWidget {
  const PortfolioFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final portfolioProvider = context.watch<PortfolioProvider>();

    return Scaffold(
      appBar: CustomAppBar(title: 'Add Portfolio'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: portfolioProvider.formKey,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: _contentInputField(context, portfolioProvider),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (portfolioProvider.validateForm()) {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Confirm Add Portfolio'),
                                  content: const Text(
                                    'Are you sure want to cancel?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Cancel'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        if (portfolioProvider.stack.isEmpty) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                "Stack is required",
                                              ),
                                            ),
                                          );
                                          return;
                                        }

                                        if (portfolioProvider.completionDate ==
                                            null) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                "Completion date is required",
                                              ),
                                            ),
                                          );
                                          return;
                                        }

                                        if (portfolioProvider.image == null) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                "Image is required",
                                              ),
                                            ),
                                          );
                                          return;
                                        }

                                        portfolioProvider.addPortfolio();
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Portfolio item added successfully',
                                            ),
                                          ),
                                        );
                                        portfolioProvider.resetForm();
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      },
                                      child: const Text("Save"),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                        child: const Text("Save"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _contentInputField(
  BuildContext context,
  PortfolioProvider portfolioProvider,
) {
  final InputDecoration fieldDecoration = InputDecoration(
    filled: true,
    fillColor: Colors.black,
    contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(
        color: Theme.of(context).colorScheme.primary,
        width: 1,
      ),
    ),
  );

  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            onPressed: portfolioProvider.pickImage,
            child: Text("Pick Image"),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: portfolioProvider.image != null
                  ? Image.file(portfolioProvider.image!, height: 150)
                  : Text("No image selected"),
            ),
          ),
        ],
      ),

      const SizedBox(height: 16),

      TextFormField(
        controller: portfolioProvider.titleController,
        decoration: fieldDecoration.copyWith(labelText: "Title"),
        autofillHints: const [AutofillHints.jobTitle],
        validator: (value) {
          if (value == null || value.isEmpty) {
            "Title is required";
          }
          if (value!.length < 3) {
            return 'Name must be at least 3 characters';
          }
          return null;
        },
      ),
      const SizedBox(height: 16),

      TextFormField(
        controller: portfolioProvider.descriptionController,
        decoration: fieldDecoration.copyWith(labelText: "Description"),
        maxLines: 3,
        validator: (value) => (value == null || value.trim().isEmpty)
            ? "Description is required"
            : null,
      ),
      const SizedBox(height: 16),

      DropdownButtonFormField<String>(
        decoration: fieldDecoration.copyWith(labelText: 'Category'),
        value: portfolioProvider.category,
        items: portfolioProvider.categories
            .map(
              (category) =>
                  DropdownMenuItem(value: category, child: Text(category)),
            )
            .toList(),
        onChanged: portfolioProvider.setCategory,
        validator: (value) => value == null ? 'Please select a category' : null,
      ),
      const SizedBox(height: 16),

      TextFormField(
        controller: portfolioProvider.stackController,
        decoration: fieldDecoration.copyWith(
          labelText: "Add Tech Stack",
          suffixIcon: IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              final value = portfolioProvider.stackController.text.trim();
              if (value.isNotEmpty) {
                portfolioProvider.setStack(value);
                portfolioProvider.stackController.clear();
              }
            },
          ),
        ),
      ),
      const SizedBox(height: 8),
      Wrap(
        spacing: 8,
        children: portfolioProvider.stack.map((value) {
          return StackChip(
            label: value,
            onDeleted: () {
              portfolioProvider.removeStack(value);
            },
          );
        }).toList(),
      ),
      const SizedBox(height: 16),

      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // onPressed: onPickDate,
          ElevatedButton.icon(
            onPressed: () => portfolioProvider.pickDate(context),
            icon: const Icon(Icons.calendar_today, size: 18),
            label: const Text('Pick Date'),
            style: ElevatedButton.styleFrom(),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
              decoration: BoxDecoration(
                // color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      portfolioProvider.completionDate == null
                          ? 'No date selected'
                          : DateFormat('dd/MM/yyyy').format(
                              portfolioProvider.completionDate!.toLocal(),
                            ),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 14,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(
                    Icons.event,
                    size: 18,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 16),

      TextFormField(
        controller: portfolioProvider.linkController,
        decoration: fieldDecoration.copyWith(labelText: "Link (optional)"),
        validator: (value) {
          if (value == null || value.isEmpty) return null;
          final urlPattern =
              r'^(http|https):\/\/([\w\-]+\.)+[\w\-]+(\/[\w\- ./?%&=]*)?$';
          final regex = RegExp(urlPattern);
          if (!regex.hasMatch(value)) {
            return "Enter a valid URL";
          }
          return null;
        },
      ),
      const SizedBox(height: 16),
    ],
  );
}
