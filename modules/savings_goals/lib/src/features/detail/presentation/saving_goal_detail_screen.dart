import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localizations/localizations.dart';
import 'package:navigation/navigation.dart';
import 'package:savings_goals/src/features/detail/presentation/providers/saving_goal_detail_controller.dart';
import 'package:savings_goals/src/features/detail/presentation/providers/saving_goal_detail_state_provider.dart';
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

  @override
  Widget build(BuildContext context) {
    final detailProvider = savingsGoalDetailControllerProvider(
      widget.childId,
      widget.goalId,
    );
    final state = ref.watch(detailProvider);
    final controller = ref.read(detailProvider.notifier);
    final contributionForm = ref.watch(
      savingGoalDetailFormStateControllerProvider(
        widget.childId,
        widget.goalId,
      ),
    );
    final contributionFormNotifier = ref.read(
      savingGoalDetailFormStateControllerProvider(
        widget.childId,
        widget.goalId,
      ).notifier,
    );

    ref.listen(detailProvider, (previous, next) async {
      final previousGoal = previous?.value;
      final nextGoal = next.asData?.value;

      if (previousGoal != null &&
          nextGoal != null &&
          !previousGoal.isCompleted &&
          nextGoal.isCompleted) {
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

      await next.showErrorOn(context);
    });

    return Scaffold(
      appBar: AppBar(title: Text(context.translate(I18n.savingsGoalDetailTitle))),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: state.when(
          skipLoadingOnReload: true,
          loading: () => const Center(child: LoadingIndicator()),
          error: (error, _) => Center(
            child: PrimaryButton(
              label: context.translate(I18n.retry),
              onPressed: () => ref.invalidate(detailProvider),
            ),
          ),
          data: (goal) {
            final progress = goal.progressPercent;
            final parsedContribution = contributionForm.parsedContributionAmount;
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
                SfNumberInput(
                  label: context.translate(I18n.savingsGoalContributionLabel),
                  controller: _amountController,
                  onChanged: (value) => contributionFormNotifier.updateContributionAmount(value),
                  errorText: contributionForm.contributionErrorKey == null
                      ? null
                      : context.translate(contributionForm.contributionErrorKey!),
                ),
                const Spacer(),
                PrimaryButton(
                  label: context.translate(I18n.confirm),
                  isLoading: state.isLoading,
                  onPressed: parsedContribution == null || state.isLoading
                      ? null
                      : () async {
                        await controller.addContribution(parsedContribution);
                        _amountController.clear(); 
                        contributionFormNotifier.updateContributionAmount('');
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
