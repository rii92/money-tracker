import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:money_tracker/blocs/blocs.dart';
import 'package:money_tracker/models/models.dart';

class BudgetsScreen extends StatelessWidget {
  const BudgetsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Month selector
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: () {
                  // TODO: Previous month
                },
              ),
              Text(
                DateFormat('MMMM yyyy').format(DateTime.now()),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: () {
                  // TODO: Next month
                },
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Budgets list
          Expanded(
            child: BlocBuilder<BudgetBloc, BudgetState>(
              builder: (context, state) {
                if (state is BudgetLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is BudgetLoaded) {
                  if (state.budgets.isEmpty) {
                    return const Center(
                      child: Text('No budgets yet. Add one!'),
                    );
                  }

                  return ListView.builder(
                    itemCount: state.budgets.length,
                    itemBuilder: (context, index) {
                      final budget = state.budgets[index];
                      return BudgetListItem(budget: budget);
                    },
                  );
                }

                if (state is BudgetError) {
                  return Center(child: Text('Error: ${state.message}'));
                }

                return const Center(child: Text('No budgets found'));
              },
            ),
          ),
        ],
      ),
    );
  }
}

class BudgetListItem extends StatelessWidget {
  final Budget budget;

  const BudgetListItem({super.key, required this.budget});

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  budget.category,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${formatter.format(budget.amount)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Spent', style: TextStyle(fontSize: 16)),
                Text(
                  '${formatter.format(budget.spent)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Remaining', style: TextStyle(fontSize: 16)),
                Text(
                  '${formatter.format(budget.amount - budget.spent)}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color:
                        budget.amount - budget.spent >= 0
                            ? Colors.green
                            : Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: budget.amount > 0 ? budget.spent / budget.amount : 0,
              backgroundColor: Colors.grey.shade200,
              color: budget.spent <= budget.amount ? Colors.green : Colors.red,
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        ),
      ),
    );
  }
}
