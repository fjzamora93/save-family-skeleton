import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:localizations/localizations.dart';
import 'package:sf_shared/sf_shared.dart';

class SavingsGoalsErrorView extends StatelessWidget {
  const SavingsGoalsErrorView({
    super.key,
    required this.onRetry,
    required this.error,
  });

  final VoidCallback onRetry;
  final Object error;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              formatErrorMessage(error),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            PrimaryButton(
              label: context.translate(I18n.retry),
              onPressed: onRetry,
            ),
          ],
        ),
      ),
    );
  }
}
