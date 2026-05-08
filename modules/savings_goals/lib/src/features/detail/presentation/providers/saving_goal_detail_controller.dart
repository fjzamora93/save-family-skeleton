import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:savings_goals/src/core/domain/entities/savings_goal.dart';
import 'package:savings_goals/src/core/providers/core_providers.dart';

part 'saving_goal_detail_controller.g.dart';

@riverpod
class SavingsGoalDetailController extends _$SavingsGoalDetailController {
  @override
  FutureOr<SavingsGoal> build(String childId, String goalId) {
    final repository = ref.watch(savingsGoalsRepositoryProvider);
    return repository.getGoalById(childId, goalId);
  }

  Future<void> addContribution(double amount) async {
    final previous = state.asData?.value;
    if (previous == null || amount <= 0) {
      return;
    }

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(savingsGoalsRepositoryProvider);
      final updatedAmount = previous.currentAmount + amount;
      await repository.updateProgress(goalId, updatedAmount);
      return previous.copyWith(currentAmount: updatedAmount);
    });
  }
}
