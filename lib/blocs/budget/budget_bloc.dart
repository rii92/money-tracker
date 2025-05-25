import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_tracker/blocs/budget/budget_event.dart';
import 'package:money_tracker/blocs/budget/budget_state.dart';
import 'package:money_tracker/models/models.dart';

class BudgetBloc extends Bloc<BudgetEvent, BudgetState> {
  // Temporary in-memory storage
  final List<Budget> _budgets = [];

  BudgetBloc() : super(BudgetInitial()) {
    on<LoadBudgets>((event, emit) {
      emit(BudgetLoading());
      try {
        emit(BudgetLoaded(_budgets));
      } catch (e) {
        emit(BudgetError(e.toString()));
      }
    });

    on<AddBudget>((event, emit) {
      final currentState = state;
      if (currentState is BudgetLoaded) {
        try {
          _budgets.add(event.budget);
          emit(BudgetLoaded(List.from(_budgets)));
        } catch (e) {
          emit(BudgetError(e.toString()));
        }
      }
    });

    on<UpdateBudget>((event, emit) {
      final currentState = state;
      if (currentState is BudgetLoaded) {
        try {
          final index = _budgets.indexWhere((b) => b.id == event.budget.id);
          if (index != -1) {
            _budgets[index] = event.budget;
            emit(BudgetLoaded(List.from(_budgets)));
          }
        } catch (e) {
          emit(BudgetError(e.toString()));
        }
      }
    });

    on<DeleteBudget>((event, emit) {
      final currentState = state;
      if (currentState is BudgetLoaded) {
        try {
          _budgets.removeWhere((b) => b.id == event.id);
          emit(BudgetLoaded(List.from(_budgets)));
        } catch (e) {
          emit(BudgetError(e.toString()));
        }
      }
    });
  }
}
