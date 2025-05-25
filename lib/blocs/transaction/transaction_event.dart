import 'package:equatable/equatable.dart';
import 'package:money_tracker/models/models.dart';

abstract class TransactionEvent extends Equatable {
  const TransactionEvent();

  @override
  List<Object> get props => [];
}

class LoadTransactions extends TransactionEvent {}

class AddTransaction extends TransactionEvent {
  final Transaction transaction;

  const AddTransaction(this.transaction);

  @override
  List<Object> get props => [transaction];
}

class UpdateTransaction extends TransactionEvent {
  final Transaction transaction;

  const UpdateTransaction(this.transaction);

  @override
  List<Object> get props => [transaction];
}

class DeleteTransaction extends TransactionEvent {
  final String id;

  const DeleteTransaction(this.id);

  @override
  List<Object> get props => [id];
}
