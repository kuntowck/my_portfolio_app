import 'package:flutter/material.dart';
import 'package:my_portfolio_app/models/portfolio_model.dart';
import 'package:my_portfolio_app/providers/portfolio_provider.dart';
import 'package:my_portfolio_app/routes.dart';
import 'package:my_portfolio_app/widgets/stack_chip.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class PortfolioScreen extends StatefulWidget {
  const PortfolioScreen({super.key});

  @override
  State<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    Future.microtask(() => context.read<PortfolioProvider>().loadPortfolios());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final portfolioProvider = context.watch<PortfolioProvider>();
    // print("portfolio screen error message: $portfolioProvider.errorMessage");

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Projects",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF7B5FFF),
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: portfolioProvider.categories
              .map((category) => Tab(text: category))
              .toList(),
        ),
      ),
      body: portfolioProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : portfolioProvider.errorMessage != null
          ? Center(child: Text(portfolioProvider.errorMessage!))
          : TabBarView(
              controller: _tabController,
              children: portfolioProvider.categories
                  .map(
                    (category) => buildProjectList(portfolioProvider, category),
                  )
                  .toList(),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => PortfolioFormScreen()),
          // );
          Navigator.pushNamed(context, AppRoutes.addPortfolio);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

Widget buildProjectList(PortfolioProvider provider, String category) {
  final filteredCategory = provider.portfolios
      .where((p) => p.category == category)
      .toList();

  if (filteredCategory.isEmpty) {
    return const Center(child: Text('No projects found'));
  }

  return ListView.builder(
    padding: const EdgeInsets.all(16),
    itemCount: filteredCategory.length,
    itemBuilder: (context, index) {
      return _card(index + 1, filteredCategory[index]);
    },
  );
}

Card _card(int index, Portfolio portfolio) {
  return Card(
    margin: EdgeInsets.only(bottom: 8.0),
    child: Column(
      children: [
        portfolio.imageUrl == ''
            ? Image.asset(
                'assets/img/noimage.png',
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              )
            : Image.network(
                "http://192.168.1.7:5144${portfolio.imageUrl}",
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
              Text(DateFormat('MMM yyyy').format(portfolio.completionDate)),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(portfolio.description),
              const SizedBox(height: 4),
              Wrap(
                spacing: 8,
                children: portfolio.stack.map((value) {
                  return StackChip(label: value);
                }).toList(),
              ),
              const SizedBox(height: 4),
              if (portfolio.projectLink != null &&
                  portfolio.projectLink!.isNotEmpty)
                TextButton(
                  onPressed: () => {},
                  child: const Text('View Project'),
                ),
            ],
          ),
          isThreeLine: true,
        ),
      ],
    ),
  );
}
