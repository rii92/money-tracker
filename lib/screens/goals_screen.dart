import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:money_tracker/blocs/blocs.dart';
import 'package:money_tracker/models/models.dart';

class GoalsScreen extends StatelessWidget {
  const GoalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filter options
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                FilterChip(
                  label: const Text('All'),
                  selected: true,
                  onSelected: (selected) {},
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('In Progress'),
                  selected: false,
                  onSelected: (selected) {},
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Completed'),
                  selected: false,
                  onSelected: (selected) {},
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Goals list
          Expanded(
            child: BlocBuilder<GoalBloc, GoalState>(
              builder: (context, state) {
                if (state is GoalLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                if (state is GoalLoaded) {
                  if (state.goals.isEmpty) {
                    return const Center(
                      child: Text('No financial goals yet. Add one!'),
                    );
                  }
                  
                  // Sort goals by completion percentage
                  final sortedGoals = List<Goal>.from(state.goals)
                    ..sort((a, b) => (b.currentAmount / b.targetAmount)
                        .compareTo(a.currentAmount / a.targetAmount));
                  
                  return ListView.builder(
                    itemCount: sortedGoals.length,
                    itemBuilder: (context, index) {
                      final goal = sortedGoals[index];
                      return GoalListItem(goal: goal);
                    },
                  );
                }
                
                if (state is GoalError) {
                  return Center(child: Text('Error: ${state.message}'));
                }
                
                return const Center(child: Text('No goals found'));
              },
            ),
          ),
        ],
      ),
    );
  }
}

class GoalListItem extends StatelessWidget {
  final Goal goal;
  
  const GoalListItem({
    super.key,
    required this.goal,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );
    
    final progress = goal.targetAmount > 0 
        ? goal.currentAmount / goal.targetAmount 
        : 0.0;
    
    final isCompleted = progress >= 1.0;
    
    // Calculate days remaining
    final daysRemaining = goal.targetDate.difference(DateTime.now()).inDays;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    goal.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (isCompleted)
                  const Chip(
                    label: Text('Completed'),
                    backgroundColor: Colors.green,
                    labelStyle: TextStyle(color: Colors.white),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(goal.description),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${formatter.format(goal.currentAmount)} / ${formatter.format(goal.targetAmount)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${(progress * 100).toStringAsFixed(1)}%',
                  style: TextStyle(
                    color: isCompleted ? Colors.green : Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey.shade200,
              color: isCompleted ? Colors.green : Colors.blue,
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Target: ${DateFormat('dd MMM yyyy').format(goal.targetDate)}',
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
                Text(
                  daysRemaining > 0 
                      ? '$daysRemaining days left' 
                      : 'Deadline passed',
                  style: TextStyle(
                    color: daysRemaining > 0 ? Colors.grey : Colors.red,
                    fontWeight: daysRemaining <= 0 ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}