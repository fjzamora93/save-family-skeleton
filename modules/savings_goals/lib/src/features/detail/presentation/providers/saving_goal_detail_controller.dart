import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:savings_goals/src/core/domain/entities/savings_goal.dart';
import 'package:savings_goals/src/core/domain/usecases/savings_goal_use_cases.dart';
import 'package:savings_goals/src/core/providers/core_providers.dart';
import 'package:savings_goals/src/features/list/presentation/providers/savings_goals_list_controller.dart';

part 'saving_goal_detail_controller.g.dart';

@riverpod
class SavingsGoalDetailController extends _$SavingsGoalDetailController {
  late SavingsGoalUseCases _useCases;

  @override
  FutureOr<SavingsGoal> build(String childId, String goalId) {
    _useCases = ref.watch(savingsGoalUseCasesProvider);
    return _useCases.getGoalById(childId: childId, goalId: goalId);
  }

  Future<void> addContribution(double amount) async {
    if (state.isLoading || amount <= 0) {
      return;
    }
    final previousGoal = state.asData?.value;
    if (previousGoal == null) {
      return;
    }
    state = const AsyncLoading<SavingsGoal>();
    state = await AsyncValue.guard(() async {
      return _useCases.addContribution(
        goalId: goalId,
        previousGoal: previousGoal,
        targetAmount: previousGoal.targetAmount,
        contributionAmount: amount,
      );
    });
    ref.invalidate(savingsGoalsListControllerProvider(childId));

  }
}
