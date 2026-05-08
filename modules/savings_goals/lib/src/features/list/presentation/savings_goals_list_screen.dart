import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localizations/localizations.dart';
import 'package:navigation/navigation.dart';
import 'package:savings_goals/src/core/domain/entities/savings_goal.dart';
import 'package:savings_goals/src/features/list/presentation/providers/savings_goals_list_controller.dart';
import 'package:sf_shared/sf_shared.dart';

class SavingsGoalsListScreen extends ConsumerWidget {
  const SavingsGoalsListScreen({
    super.key,
    required this.childId,
    required this.navigationContract,
  });

  final String childId;
  final NavigationContract navigationContract;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(savingsGoalsListControllerProvider(childId));
    final controller = ref.read(
      savingsGoalsListControllerProvider(childId).notifier,
    );

    ref.listen(
      savingsGoalsListControllerProvider(childId),
      (_, next) => next.showErrorOn(context),
    );

    return Scaffold(
      appBar: AppBar(title: Text(context.translate(I18n.savingsGoalsTitle))),
      body: state.when(
        skipLoadingOnReload: true,
        loading: () => const Center(child: LoadingIndicator()),
        error: (error, _) => _ErrorView(onRetry: controller.refresh, error: error),
        data: (goals) => goals.isEmpty
            ? _EmptyView(
                onCreate: () => navigationContract.goToCreate(childId),
              )
            : RefreshIndicator(
                onRefresh: controller.refresh,
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: goals.length,
                  itemBuilder: (context, index) {
                    final goal = goals[index];
                    return _SavingsGoalCard(
                      goal: goal,
                      onTap: () =>
                          navigationContract.goToDetail(childId, goal.id),
                      onDelete: () => controller.deleteGoal(goal.id),
                    );
                  },
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => navigationContract.goToCreate(childId),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.onRetry, required this.error});

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

class _EmptyView extends StatelessWidget {
  const _EmptyView({required this.onCreate});

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

class _SavingsGoalCard extends StatelessWidget {
  const _SavingsGoalCard({
    required this.goal,
    required this.onTap,
    required this.onDelete,
  });

  final SavingsGoal goal;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final progress = goal.progress.clamp(0.0, 1.0);
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
