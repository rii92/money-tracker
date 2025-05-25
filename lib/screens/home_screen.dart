import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:money_tracker/blocs/blocs.dart';
import 'package:money_tracker/models/models.dart';
import 'package:money_tracker/screens/accounts_screen.dart';
import 'package:money_tracker/screens/budgets_screen.dart';
import 'package:money_tracker/screens/goals_screen.dart';
import 'package:money_tracker/screens/transactions_screen.dart';
import 'package:money_tracker/widgets/budget_overview.dart';
import 'package:money_tracker/widgets/recent_transactions.dart';
import 'package:money_tracker/widgets/summary_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // Load initial data
    context.read<TransactionBloc>().add(LoadTransactions());
    context.read<BudgetBloc>().add(LoadBudgets());
    context.read<AccountBloc>().add(LoadAccounts());
    context.read<GoalBloc>().add(LoadGoals());

    // Add some sample data for demonstration
    _addSampleData();
  }

  void _addSampleData() {
    // Add sample accounts
    context.read<AccountBloc>().add(
      AddAccount(
        Account(
          id: '1',
          name: 'Cash Wallet',
          type: AccountType.cash,
          balance: 1500000,
        ),
      ),
    );

    context.read<AccountBloc>().add(
      AddAccount(
        Account(
          id: '2',
          name: 'BCA Savings',
          type: AccountType.bank,
          balance: 5000000,
          institution: 'BCA',
        ),
      ),
    );

    // Add sample transactions
    context.read<TransactionBloc>().add(
      AddTransaction(
        Transaction(
          id: '1',
          description: 'Salary',
          amount: 8000000,
          date: DateTime.now().subtract(const Duration(days: 2)),
          type: TransactionType.income,
          category: 'Salary',
          accountId: '2',
        ),
      ),
    );

    context.read<TransactionBloc>().add(
      AddTransaction(
        Transaction(
          id: '2',
          description: 'Groceries',
          amount: 350000,
          date: DateTime.now().subtract(const Duration(days: 1)),
          type: TransactionType.expense,
          category: 'Food',
          accountId: '1',
        ),
      ),
    );

    context.read<TransactionBloc>().add(
      AddTransaction(
        Transaction(
          id: '3',
          description: 'Electricity Bill',
          amount: 500000,
          date: DateTime.now(),
          type: TransactionType.expense,
          category: 'Utilities',
          accountId: '2',
        ),
      ),
    );

    // Add sample budgets
    context.read<BudgetBloc>().add(
      AddBudget(
        Budget(
          id: '1',
          category: 'Food',
          amount: 2000000,
          spent: 350000,
          startDate: DateTime(DateTime.now().year, DateTime.now().month, 1),
          endDate: DateTime(DateTime.now().year, DateTime.now().month + 1, 0),
        ),
      ),
    );

    context.read<BudgetBloc>().add(
      AddBudget(
        Budget(
          id: '2',
          category: 'Utilities',
          amount: 1000000,
          spent: 500000,
          startDate: DateTime(DateTime.now().year, DateTime.now().month, 1),
          endDate: DateTime(DateTime.now().year, DateTime.now().month + 1, 0),
        ),
      ),
    );

    // Add sample goals
    context.read<GoalBloc>().add(
      AddGoal(
        Goal(
          id: '1',
          name: 'Emergency Fund',
          description: 'Save 6 months of expenses for emergencies',
          targetAmount: 30000000,
          currentAmount: 10000000,
          targetDate: DateTime.now().add(const Duration(days: 365)),
          createdDate: DateTime.now().subtract(const Duration(days: 30)),
        ),
      ),
    );

    context.read<GoalBloc>().add(
      AddGoal(
        Goal(
          id: '2',
          name: 'New Laptop',
          description: 'Save for a new MacBook Pro',
          targetAmount: 25000000,
          currentAmount: 5000000,
          targetDate: DateTime.now().add(const Duration(days: 180)),
          createdDate: DateTime.now().subtract(const Duration(days: 60)),
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Money Tracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: Show notifications
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              // TODO: Show settings
            },
          ),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Add new transaction/budget/account/goal based on current tab
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            activeIcon: Icon(Icons.receipt_long),
            label: 'Transactions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet_outlined),
            activeIcon: Icon(Icons.account_balance_wallet),
            label: 'Accounts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart_outline),
            activeIcon: Icon(Icons.pie_chart),
            label: 'Budgets',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.flag_outlined),
            activeIcon: Icon(Icons.flag),
            label: 'Goals',
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return _buildHomeTab();
      case 1:
        return const TransactionsScreen();
      case 2:
        return const AccountsScreen();
      case 3:
        return const BudgetsScreen();
      case 4:
        return const GoalsScreen();
      default:
        return _buildHomeTab();
    }
  }

  Widget _buildHomeTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Financial summary
          BlocBuilder<TransactionBloc, TransactionState>(
            builder: (context, state) {
              if (state is TransactionLoaded) {
                final income = state.transactions
                    .where((t) => t.type == TransactionType.income)
                    .fold(0.0, (sum, t) => sum + t.amount);

                final expense = state.transactions
                    .where((t) => t.type == TransactionType.expense)
                    .fold(0.0, (sum, t) => sum + t.amount);

                final balance = income - expense;

                return Column(
                  children: [
                    // Total balance
                    Card(
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
                              ).format(balance),
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Income and expense summary
                    Row(
                      children: [
                        Expanded(
                          child: SummaryCard(
                            title: 'Income',
                            amount: income,
                            icon: Icons.arrow_downward,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: SummaryCard(
                            title: 'Expense',
                            amount: expense,
                            icon: Icons.arrow_upward,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),

          const SizedBox(height: 24),

          // Budget overview
          const Text(
            'Budget Overview',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const BudgetOverview(),

          const SizedBox(height: 24),

          // Recent transactions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent Transactions',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _selectedIndex = 1; // Switch to transactions tab
                  });
                },
                child: const Text('See All'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const RecentTransactions(),
        ],
      ),
    );
  }
}
