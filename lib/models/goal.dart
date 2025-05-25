class Goal {
  final String id;
  final String name;
  final String description;
  final double targetAmount;
  final double currentAmount;
  final DateTime targetDate;
  final DateTime createdDate;

  Goal({
    required this.id,
    required this.name,
    required this.description,
    required this.targetAmount,
    required this.currentAmount,
    required this.targetDate,
    required this.createdDate,
  });
}
