import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:money_tracker/blocs/blocs.dart';
import 'package:money_tracker/models/models.dart';

class AccountsScreen extends StatelessWidget {
  const AccountsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Total balance card
          BlocBuilder<AccountBloc, AccountState>(
            builder: (context, state) {
              if (state is AccountLoaded) {
                final totalBalance = state.accounts.fold(
                  0.0, (sum, account) => sum + account.balance);
                
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const Text(
                          'Total Balance',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          NumberFormat.currency(
                            locale: 'id_ID',
                            symbol: 'Rp',
                            decimalDigits: 0,
                          ).format(totalBalance),
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          
          const SizedBox(height: 16),
          const Text(
            'Your Accounts',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Accounts list
          Expanded(
            child: BlocBuilder<AccountBloc, AccountState>(
              builder: (context, state) {
                if (state is AccountLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                if (state is AccountLoaded) {
                  if (state.accounts.isEmpty) {
                    return const Center(
                      child: Text('No accounts yet. Add one!'),
                    );
                  }
                  
                  // Sort accounts by balance (highest first)
                  final sortedAccounts = List<Account>.from(state.accounts)
                    ..sort((a, b) => b.balance.compareTo(a.balance));
                  
                  return ListView.builder(
                    itemCount: sortedAccounts.length,
                    itemBuilder: (context, index) {
                      final account = sortedAccounts[index];
                      return AccountListItem(account: account);
                    },
                  );
                }
                
                if (state is AccountError) {
                  return Center(child: Text('Error: ${state.message}'));
                }
                
                return const Center(child: Text('No accounts found'));
              },
            ),
          ),
        ],
      ),
    );
  }
}

class AccountListItem extends StatelessWidget {
  final Account account;
  
  const AccountListItem({
    super.key,
    required this.account,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );
    
    IconData getAccountIcon() {
      switch (account.type) {
        case AccountType.cash:
          return Icons.money;
        case AccountType.bank:
          return Icons.account_balance;
        case AccountType.creditCard:
          return Icons.credit_card;
        case AccountType.investment:
          return Icons.trending_up;
        case AccountType.other:
          return Icons.account_balance_wallet;
      }
    }
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue.shade100,
          child: Icon(
            getAccountIcon(),
            color: Colors.blue,
          ),
        ),
        title: Text(
          account.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(account.type.toString().split('.').last),
        trailing: Text(
          formatter.format(account.balance),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        onTap: () {
          // TODO: Show account details
        },
      ),
    );
  }
}