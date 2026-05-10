import 'package:flutter/material.dart';
import 'package:savings_goals/src/core/domain/entities/savings_goal.dart';
import 'package:savings_goals/src/features/list/presentation/widgets/savings_goal_card.dart';

class SavingsGoalsListView extends StatelessWidget {
  const SavingsGoalsListView({
    super.key,
    required this.goals,
    required this.onRefresh,
    required this.onGoalTap,
    required this.onGoalDelete,
  });

  final List<SavingsGoal> goals;
  final Future<void> Function() onRefresh;
  final void Function(SavingsGoal goal) onGoalTap;
  final void Function(SavingsGoal goal) onGoalDelete;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: goals.length,
        itemBuilder: (context, index) {
          final goal = goals[index];
          return SavingsGoalCard(
            goal: goal,
            onTap: () => onGoalTap(goal),
            onDelete: () => onGoalDelete(goal),
          );
        },
      ),
    );
  }
}
