import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_tracker/blocs/transaction/transaction_event.dart';
import 'package:money_tracker/blocs/transaction/transaction_state.dart';
import 'package:money_tracker/models/models.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  // Temporary in-memory storage
  final List<Transaction> _transactions = [];

  TransactionBloc() : super(TransactionInitial()) {
    on<LoadTransactions>((event, emit) {
      emit(TransactionLoading());
      try {
        emit(TransactionLoaded(_transactions));
      } catch (e) {
        emit(TransactionError(e.toString()));
      }
    });

    on<AddTransaction>((event, emit) {
      final currentState = state;
      if (currentState is TransactionLoaded) {
        try {
          _transactions.add(event.transaction);
          emit(TransactionLoaded(List.from(_transactions)));
        } catch (e) {
          emit(TransactionError(e.toString()));
        }
      }
    });

    on<UpdateTransaction>((event, emit) {
      final currentState = state;
      if (currentState is TransactionLoaded) {
        try {
          final index = _transactions.indexWhere(
            (t) => t.id == event.transaction.id,
          );
          if (index != -1) {
            _transactions[index] = event.transaction;
            emit(TransactionLoaded(List.from(_transactions)));
          }
        } catch (e) {
          emit(TransactionError(e.toString()));
        }
      }
    });

    on<DeleteTransaction>((event, emit) {
      final currentState = state;
      if (currentState is TransactionLoaded) {
        try {
          _transactions.removeWhere((t) => t.id == event.id);
          emit(TransactionLoaded(List.from(_transactions)));
        } catch (e) {
          emit(TransactionError(e.toString()));
        }
      }
    });
  }
}
