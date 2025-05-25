import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:money_tracker/blocs/blocs.dart';
import 'package:money_tracker/models/models.dart';

class BudgetOverview extends StatelessWidget {
  const BudgetOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BudgetBloc, BudgetState>(
      builder: (context, state) {
        if (state is BudgetLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is BudgetLoaded) {
          if (state.budgets.isEmpty) {
            return const Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('No budgets yet. Add one to track your spending!'),
              ),
            );
          }

          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.budgets.length,
            itemBuilder: (context, index) {
              return BudgetOverviewItem(budget: state.budgets[index]);
            },
          );
        }

        if (state is BudgetError) {
          return Center(child: Text('Error: ${state.message}'));
        }

        return const SizedBox.shrink();
      },
    );
  }
}

class BudgetOverviewItem extends StatelessWidget {
  final Budget budget;

  const BudgetOverviewItem({super.key, required this.budget});

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );

    final progress = budget.amount > 0 ? budget.spent / budget.amount : 0.0;
    final isOverBudget = progress > 1.0;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  budget.category,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  '${formatter.format(budget.spent)} / ${formatter.format(budget.amount)}',
                  style: TextStyle(
                    color: isOverBudget ? Colors.red : null,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: isOverBudget ? 1.0 : progress.toDouble(),
              backgroundColor: Colors.grey.shade200,
              color: isOverBudget ? Colors.red : Colors.blue,
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 4),
            Text(
              isOverBudget
                  ? 'Over budget by ${formatter.format(budget.spent - budget.amount)}'
                  : '${(progress * 100).toStringAsFixed(0)}% used',
              style: TextStyle(
                fontSize: 12,
                color: isOverBudget ? Colors.red : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
