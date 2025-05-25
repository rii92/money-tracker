import 'package:equatable/equatable.dart';
import 'package:money_tracker/models/models.dart';

abstract class BudgetEvent extends Equatable {
  const BudgetEvent();

  @override
  List<Object> get props => [];
}

class LoadBudgets extends BudgetEvent {}

class AddBudget extends BudgetEvent {
  final Budget budget;

  const AddBudget(this.budget);

  @override
  List<Object> get props => [budget];
}

class UpdateBudget extends BudgetEvent {
  final Budget budget;

  const UpdateBudget(this.budget);

  @override
  List<Object> get props => [budget];
}

class DeleteBudget extends BudgetEvent {
  final String id;

  const DeleteBudget(this.id);

  @override
  List<Object> get props => [id];
}
