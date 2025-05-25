enum AccountType { cash, bank, creditCard, investment, other }

class Account {
  final String id;
  final String name;
  final AccountType type;
  final double balance;
  final String? institution;
  final String? notes;

  Account({
    required this.id,
    required this.name,
    required this.type,
    required this.balance,
    this.institution,
    this.notes,
  });
}
