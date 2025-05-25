import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_tracker/blocs/account/account_event.dart';
import 'package:money_tracker/blocs/account/account_state.dart';
import 'package:money_tracker/models/models.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  // Temporary in-memory storage
  final List<Account> _accounts = [];

  AccountBloc() : super(AccountInitial()) {
    on<LoadAccounts>((event, emit) {
      emit(AccountLoading());
      try {
        emit(AccountLoaded(_accounts));
      } catch (e) {
        emit(AccountError(e.toString()));
      }
    });

    on<AddAccount>((event, emit) {
      final currentState = state;
      if (currentState is AccountLoaded) {
        try {
          _accounts.add(event.account);
          emit(AccountLoaded(List.from(_accounts)));
        } catch (e) {
          emit(AccountError(e.toString()));
        }
      }
    });

    on<UpdateAccount>((event, emit) {
      final currentState = state;
      if (currentState is AccountLoaded) {
        try {
          final index = _accounts.indexWhere((a) => a.id == event.account.id);
          if (index != -1) {
            _accounts[index] = event.account;
            emit(AccountLoaded(List.from(_accounts)));
          }
        } catch (e) {
          emit(AccountError(e.toString()));
        }
      }
    });

    on<DeleteAccount>((event, emit) {
      final currentState = state;
      if (currentState is AccountLoaded) {
        try {
          _accounts.removeWhere((a) => a.id == event.id);
          emit(AccountLoaded(List.from(_accounts)));
        } catch (e) {
          emit(AccountError(e.toString()));
        }
      }
    });
  }
}
