import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_tracker/blocs/goal/goal_event.dart';
import 'package:money_tracker/blocs/goal/goal_state.dart';
import 'package:money_tracker/models/models.dart';

class GoalBloc extends Bloc<GoalEvent, GoalState> {
  // Temporary in-memory storage
  final List<Goal> _goals = [];

  GoalBloc() : super(GoalInitial()) {
    on<LoadGoals>((event, emit) {
      emit(GoalLoading());
      try {
        emit(GoalLoaded(_goals));
      } catch (e) {
        emit(GoalError(e.toString()));
      }
    });

    on<AddGoal>((event, emit) {
      final currentState = state;
      if (currentState is GoalLoaded) {
        try {
          _goals.add(event.goal);
          emit(GoalLoaded(List.from(_goals)));
        } catch (e) {
          emit(GoalError(e.toString()));
        }
      }
    });

    on<UpdateGoal>((event, emit) {
      final currentState = state;
      if (currentState is GoalLoaded) {
        try {
          final index = _goals.indexWhere((g) => g.id == event.goal.id);
          if (index != -1) {
            _goals[index] = event.goal;
            emit(GoalLoaded(List.from(_goals)));
          }
        } catch (e) {
          emit(GoalError(e.toString()));
        }
      }
    });

    on<DeleteGoal>((event, emit) {
      final currentState = state;
      if (currentState is GoalLoaded) {
        try {
          _goals.removeWhere((g) => g.id == event.id);
          emit(GoalLoaded(List.from(_goals)));
        } catch (e) {
          emit(GoalError(e.toString()));
        }
      }
    });
  }
}
