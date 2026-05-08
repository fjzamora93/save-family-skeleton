import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localizations/localizations.dart';
import 'package:navigation/navigation.dart';
import 'package:savings_goals/src/core/domain/entities/savings_goal.dart';
import 'package:savings_goals/src/features/detail/presentation/providers/saving_goal_detail_controller.dart';
import 'package:sf_shared/sf_shared.dart';

class SavingGoalDetailScreen extends ConsumerStatefulWidget {
  const SavingGoalDetailScreen({
    super.key,
    required this.childId,
    required this.goalId,
    required this.navigationContract,
  });

  final String childId;
  final String goalId;
  final NavigationContract navigationContract;

  @override
  ConsumerState<SavingGoalDetailScreen> createState() =>
      _SavingGoalDetailScreenState();
}

class _SavingGoalDetailScreenState extends ConsumerState<SavingGoalDetailScreen> {
  late final TextEditingController _amountController;
  SavingsGoal? _lastResolvedGoal;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController();
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  double? get _parsedAmount {
    final value = _amountController.text.trim().replaceAll(',', '.');
    final amount = double.tryParse(value);
    if (amount == null || amount <= 0) {
      return null;
    }
    return amount;
  }

  @override
  Widget build(BuildContext context) {
    final provider = savingsGoalDetailControllerProvider(
      widget.childId,
      widget.goalId,
    );
    final state = ref.watch(provider);
    final controller = ref.read(provider.notifier);

    ref.listen(provider, (previous, next) async {
      final previousGoal = previous?.asData?.value ?? _lastResolvedGoal;
      final nextGoal = next.asData?.value;

      if (nextGoal != null) {
        final completedBefore = previousGoal?.isCompleted ?? false;
        final completedNow = nextGoal.isCompleted;
        if (!completedBefore && completedNow) {
          await showDialog<void>(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(context.translate(I18n.savingsGoalReachedTitle)),
                content: Text(context.translate(I18n.savingsGoalReachedMessage)),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(context.translate(I18n.confirm)),
                  ),
                ],
              );
            },
          );
        }
        _lastResolvedGoal = nextGoal;
      }

      await next.showErrorOn(context);
    });

    return Scaffold(
      appBar: AppBar(title: Text(context.translate(I18n.savingsGoalDetailTitle))),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: state.when(
          loading: () => const Center(child: LoadingIndicator()),
          error: (error, _) => Center(
            child: PrimaryButton(
              label: context.translate(I18n.retry),
              onPressed: () => ref.invalidate(provider),
            ),
          ),
          data: (goal) {
            final progress = goal.progress.clamp(0.0, 1.0);
            final parsedAmount = _parsedAmount;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(goal.name, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 16),
                Text(
                  context.translate(
                    I18n.savingsGoalsCurrentAmount,
                    args: {'amount': goal.currentAmount.toStringAsFixed(2)},
                  ),
                ),
                Text(
                  context.translate(
                    I18n.savingsGoalsTargetAmount,
                    args: {'amount': goal.targetAmount.toStringAsFixed(2)},
                  ),
                ),
                const SizedBox(height: 12),
                LinearProgressIndicator(value: progress),
                const SizedBox(height: 8),
                Text(
                  context.translate(
                    I18n.savingsGoalsProgress,
                    args: {'progress': (progress * 100).toStringAsFixed(0)},
                  ),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: _amountController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    labelText: context.translate(I18n.savingsGoalContributionLabel),
                    errorText: _amountController.text.isEmpty || parsedAmount != null
                        ? null
                        : context.translate(I18n.savingsGoalContributionInvalid),
                  ),
                ),
                const Spacer(),
                PrimaryButton(
                  label: context.translate(I18n.confirm),
                  isLoading: state.isLoading,
                  onPressed: parsedAmount == null || state.isLoading
                      ? null
                      : () => controller.addContribution(parsedAmount),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
