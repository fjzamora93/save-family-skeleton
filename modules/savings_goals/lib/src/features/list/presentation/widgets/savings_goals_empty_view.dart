import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:localizations/localizations.dart';

class SavingsGoalsEmptyView extends StatelessWidget {
  const SavingsGoalsEmptyView({
    super.key,
    required this.onCreate,
  });

  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              context.translate(I18n.savingsGoalsEmpty),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            PrimaryButton(
              label: context.translate(I18n.savingsGoalsCreateFirst),
              onPressed: onCreate,
            ),
          ],
        ),
      ),
    );
  }
}
