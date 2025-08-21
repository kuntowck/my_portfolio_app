import 'package:flutter/material.dart';
import 'package:my_portfolio_app/models/portfolio_model.dart';
import 'package:my_portfolio_app/providers/portfolio_provider.dart';
import 'package:my_portfolio_app/screens/portfolio_form_screen.dart';
import 'package:my_portfolio_app/widgets/custom_app_bar.dart';
import 'package:my_portfolio_app/widgets/stack_chip.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

// const String project1 = "assets/img/project1.png";
// const String project2 = "assets/img/project2.png";
// const String project3 = "assets/img/project3.png";
// const String project4 = "assets/img/project4.png";

class PortfolioScreen extends StatelessWidget {
  const PortfolioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final portfolioProvider = context.watch<PortfolioProvider>().portfolios;

    return Scaffold(
      appBar: CustomAppBar(title: 'Projects', showBack: true),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: ListView.builder(
            itemCount: portfolioProvider.length,
            itemBuilder: (context, index) {
              final portfolio = portfolioProvider[index];
              return _card(index + 1, portfolio);
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PortfolioFormScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

Card _card(int index, Portfolio portfolio) {
  return Card(
    margin: EdgeInsets.only(bottom: 8.0),
    child: Column(
      children: [
        Image.file(
          portfolio.image,
          height: 200,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
        ListTile(
          leading: CircleAvatar(
            radius: 16,
            backgroundColor: const Color(0xFF7B5FFF),
            child: Text(
              index.toString(),
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                portfolio.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              if (portfolio.completionDate != null)
                Text(DateFormat('MM/yyyy').format(portfolio.completionDate!)),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(portfolio.description),
              const SizedBox(height: 8),
              Text(portfolio.category),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: portfolio.stack.map((value) {
                  return StackChip(label: value);
                }).toList(),
              ),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (portfolio.link != null && portfolio.link!.isNotEmpty)
                TextButton(
                  onPressed: () => {},
                  child: const Text('View Project'),
                ),
              const Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),
        ),
      ],
    ),
  );
}
