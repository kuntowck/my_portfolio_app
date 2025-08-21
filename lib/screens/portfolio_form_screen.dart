import 'package:flutter/material.dart';
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: portfolioProvider.formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: portfolioProvider.titleController,
                  decoration: const InputDecoration(labelText: "Title"),
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
                  decoration: const InputDecoration(labelText: "Description"),
                  maxLines: 3,
                  validator: (value) => (value == null || value.trim().isEmpty)
                      ? "Description is required"
                      : null,
                ),
                const SizedBox(height: 16),

                DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: 'Category'),
                  value: portfolioProvider.category,
                  items: ['Web App', 'Mobile App', 'UI Design', 'Data Analyst']
                      .map(
                        (category) => DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        ),
                      )
                      .toList(),
                  onChanged: portfolioProvider.setCategory,
                  validator: (value) =>
                      value == null ? 'Please select a category' : null,
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: portfolioProvider.stackController,
                  decoration: InputDecoration(
                    labelText: "Add Tech Stack",
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        final value = portfolioProvider.stackController.text
                            .trim();
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
                  children: [
                    Expanded(
                      child: Text(
                        portfolioProvider.completionDate == null
                            ? 'No date selected'
                            : 'Selected Date: ${portfolioProvider.completionDate!.toLocal()}',
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => portfolioProvider.pickDate(context),
                      child: Text('Pick Date'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    portfolioProvider.image != null
                        ? Image.file(portfolioProvider.image!, height: 150)
                        : Text("No image selected"),
                    ElevatedButton(
                      onPressed: portfolioProvider.pickImage,
                      child: Text("Pick Image"),
                    ),
                  ],
                ),

                TextFormField(
                  controller: portfolioProvider.linkController,
                  decoration: const InputDecoration(
                    labelText: "Link (optional)",
                  ),
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

                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Confirm Add Portfolio'),
                          content: const Text('Are you sure want to cancel?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(
                                  context,
                                ); // Tutup dialog tanpa action
                              },
                              child: const Text('Cancel'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                if (portfolioProvider.validateForm()) {
                                  if (portfolioProvider.stack.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("Stack is required"),
                                      ),
                                    );
                                    return;
                                  }

                                  if (portfolioProvider.completionDate ==
                                      null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          "Completion date is required",
                                        ),
                                      ),
                                    );
                                    return;
                                  }

                                  if (portfolioProvider.image == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("Image is required"),
                                      ),
                                    );
                                    return;
                                  }

                                  portfolioProvider.addPortfolio();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Portfolio item added successfully',
                                      ),
                                    ),
                                  );
                                  portfolioProvider.resetForm();
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                }
                              },
                              child: const Text("Save"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Text("Save"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
