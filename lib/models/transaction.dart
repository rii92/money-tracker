enum TransactionType { income, expense, transfer }

class Transaction {
  final String id;
  final String description;
  final double amount;
  final DateTime date;
  final TransactionType type;
  final String category;
  final String accountId;
  final String? toAccountId; // For transfers

  Transaction({
    required this.id,
    required this.description,
    required this.amount,
    required this.date,
    required this.type,
    required this.category,
    required this.accountId,
    this.toAccountId,
  });
}
