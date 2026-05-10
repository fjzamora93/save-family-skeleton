import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localizations/localizations.dart';
import 'package:navigation/navigation.dart';
import 'package:savings_goals/src/features/list/presentation/providers/savings_goals_list_controller.dart';
import 'package:savings_goals/src/features/list/presentation/widgets/savings_goals_empty_view.dart';
import 'package:savings_goals/src/features/list/presentation/widgets/savings_goals_error_view.dart';
import 'package:savings_goals/src/features/list/presentation/widgets/savings_goals_list_view.dart';
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
        error: (error, _) => SavingsGoalsErrorView(
          onRetry: controller.refresh,
          error: error,
        ),
        data: (goals) => goals.isEmpty
            ? SavingsGoalsEmptyView(
                onCreate: () => navigationContract.goToCreate(childId),
              )
            : SavingsGoalsListView(
                goals: goals,
                onRefresh: controller.refresh,
                onGoalTap: (goal) =>
                    navigationContract.goToDetail(childId, goal.id),
                onGoalDelete: (goal) => controller.deleteGoal(goal.id),
              ),
      ),
      floatingActionButton: state.maybeWhen(
        data: (_) => FloatingActionButton(
          onPressed: () => navigationContract.goToCreate(childId),
          child: const Icon(Icons.add),
        ),
        orElse: () => null, 
      ),
    );
  }
}
