import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:money_tracker/blocs/blocs.dart';
import 'package:money_tracker/models/models.dart';

class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filter options
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                FilterChip(
                  label: const Text('All'),
                  selected: true,
                  onSelected: (selected) {},
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Income'),
                  selected: false,
                  onSelected: (selected) {},
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Expense'),
                  selected: false,
                  onSelected: (selected) {},
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('This Month'),
                  selected: false,
                  onSelected: (selected) {},
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Transactions list
          Expanded(
            child: BlocBuilder<TransactionBloc, TransactionState>(
              builder: (context, state) {
                if (state is TransactionLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is TransactionLoaded) {
                  if (state.transactions.isEmpty) {
                    return const Center(
                      child: Text('No transactions yet. Add one!'),
                    );
                  }

                  // Sort transactions by date (newest first)
                  final sortedTransactions = List<Transaction>.from(
                    state.transactions,
                  )..sort((a, b) => b.date.compareTo(a.date));

                  // Group transactions by date
                  final groupedTransactions = <DateTime, List<Transaction>>{};
                  for (final transaction in sortedTransactions) {
                    final date = DateTime(
                      transaction.date.year,
                      transaction.date.month,
                      transaction.date.day,
                    );

                    if (!groupedTransactions.containsKey(date)) {
                      groupedTransactions[date] = [];
                    }

                    groupedTransactions[date]!.add(transaction);
                  }

                  return ListView.builder(
                    itemCount: groupedTransactions.length,
                    itemBuilder: (context, index) {
                      final date = groupedTransactions.keys.elementAt(index);
                      final transactions = groupedTransactions[date]!;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              _formatDate(date),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          ...transactions.map(
                            (transaction) =>
                                TransactionListItem(transaction: transaction),
                          ),
                          const SizedBox(height: 8),
                        ],
                      );
                    },
                  );
                }

                if (state is TransactionError) {
                  return Center(child: Text('Error: ${state.message}'));
                }

                return const Center(child: Text('No transactions found'));
              },
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final yesterday = DateTime(now.year, now.month, now.day - 1);

    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      return 'Today';
    } else if (date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day) {
      return 'Yesterday';
    } else {
      return DateFormat('EEEE, d MMMM y').format(date);
    }
  }
}

class TransactionListItem extends StatelessWidget {
  final Transaction transaction;

  const TransactionListItem({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor:
              transaction.type == TransactionType.income
                  ? Colors.green.shade100
                  : Colors.red.shade100,
          child: Icon(
            transaction.type == TransactionType.income
                ? Icons.arrow_downward
                : Icons.arrow_upward,
            color:
                transaction.type == TransactionType.income
                    ? Colors.green
                    : Colors.red,
          ),
        ),
        title: Text(
          transaction.description,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(transaction.category),
        trailing: Text(
          formatter.format(transaction.amount),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color:
                transaction.type == TransactionType.income
                    ? Colors.green
                    : Colors.red,
          ),
        ),
        onTap: () {
          // TODO: Show transaction details
        },
      ),
    );
  }
}
