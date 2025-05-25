class Budget {
  final String id;
  final String category;
  final double amount;
  final double spent;
  final DateTime startDate;
  final DateTime endDate;

  Budget({
    required this.id,
    required this.category,
    required this.amount,
    required this.spent,
    required this.startDate,
    required this.endDate,
  });
}
