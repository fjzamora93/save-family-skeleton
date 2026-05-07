import 'package:flutter/material.dart';
import 'package:home/src/features/home/domain/entities/child_summary.dart';

class ChildSavingsCard extends StatelessWidget {
  final ChildSummary child;
  final VoidCallback onTap;

  const ChildSavingsCard({
    super.key,
    required this.child,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {


    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        onTap: onTap,
        title: Text(
          child.name,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              '${child.goals.length} metas · €${child.goals.fold<double>(0, (sum, goal) => sum + goal.targetAmount)} / €${child.goals.fold<double>(0, (sum, goal) => sum + goal.targetAmount)}',
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: child.goals.isNotEmpty && child.goals.any((goal) => goal.targetAmount > 0)
                ? child.goals.fold(0.0, (sum, goal) => sum + goal.currentAmount) / child.goals.fold(0.0, (sum, goal) => sum + goal.targetAmount) 
                : 0,
            ),
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}