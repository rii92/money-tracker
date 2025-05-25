import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:money_tracker/blocs/blocs.dart';
import 'package:money_tracker/models/models.dart';

class RecentTransactions extends StatelessWidget {
  const RecentTransactions({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionBloc, TransactionState>(
      builder: (context, state) {
        if (state is TransactionLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is TransactionLoaded) {
          if (state.transactions.isEmpty) {
            return const Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('No transactions yet. Add one to get started!'),
              ),
            );
          }

          // Sort transactions by date (newest first) and take the most recent 5
          final recentTransactions =
              List<Transaction>.from(state.transactions)
                ..sort((a, b) => b.date.compareTo(a.date))
                ..take(5);

          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount:
                recentTransactions.length > 5 ? 5 : recentTransactions.length,
            itemBuilder: (context, index) {
              final transaction = recentTransactions[index];

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
                  subtitle: Text(DateFormat('d MMM').format(transaction.date)),
                  trailing: Text(
                    NumberFormat.currency(
                      locale: 'id_ID',
                      symbol: 'Rp',
                      decimalDigits: 0,
                    ).format(transaction.amount),
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
            },
          );
        }

        if (state is TransactionError) {
          return Center(child: Text('Error: ${state.message}'));
        }

        return const SizedBox.shrink();
      },
    );
  }
}
