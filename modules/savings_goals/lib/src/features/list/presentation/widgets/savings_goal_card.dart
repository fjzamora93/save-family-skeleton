import 'package:flutter/material.dart';
import 'package:localizations/localizations.dart';
import 'package:savings_goals/src/core/domain/entities/savings_goal.dart';

class SavingsGoalCard extends StatelessWidget {
  final SavingsGoal goal;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  const SavingsGoalCard({
    super.key,
    required this.goal,
    required this.onDelete,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final progress = goal.progressPercent;
    return Card(
      child: ListTile(
        onTap: onTap,
        title: Text(goal.name),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.translate(
                  I18n.savingsGoalsTargetAmount,
                  args: {'amount': goal.targetAmount.toStringAsFixed(2)},
                ),
              ),
              Text(
                context.translate(
                  I18n.savingsGoalsCurrentAmount,
                  args: {'amount': goal.currentAmount.toStringAsFixed(2)},
                ),
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(value: progress),
              const SizedBox(height: 4),
              Text(
                context.translate(
                  I18n.savingsGoalsProgress,
                  args: {'progress': (progress * 100).toStringAsFixed(0)},
                ),
              ),
            ],
          ),
        ),
        trailing: IconButton(
          onPressed: onDelete,
          icon: const Icon(Icons.delete_outline),
          tooltip: context.translate(I18n.delete),
        ),
      ),
    );
  }
}
