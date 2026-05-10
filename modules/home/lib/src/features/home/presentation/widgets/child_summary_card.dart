import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:home/src/features/home/domain/entities/child_summary.dart';
import 'package:localizations/localizations.dart';

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
          style: SfTypography.titleSmall(context),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              context.translate(
                I18n.homeChildGoalsCount,
                args: {'count': '${child.goals.length}'},
              ),
            ),
        
            Text(
              context.translate(
                I18n.savingsGoalsTargetAmount,
                args: {'amount': child.targetStr},
              ),
            ),
            Text(
              context.translate(
                I18n.savingsGoalsCurrentAmount,
                args: {'amount': child.currentStr},
              ),
            ),
          ],
          
        ),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
