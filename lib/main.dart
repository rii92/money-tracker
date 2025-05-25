import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_tracker/blocs/blocs.dart';
import 'package:money_tracker/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TransactionBloc>(create: (context) => TransactionBloc()),
        BlocProvider<BudgetBloc>(create: (context) => BudgetBloc()),
        BlocProvider<AccountBloc>(create: (context) => AccountBloc()),
        BlocProvider<GoalBloc>(create: (context) => GoalBloc()),
      ],
      child: MaterialApp(
        title: 'Money Tracker',
        debugShowCheckedModeBanner: false, // Remove debug banner
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
