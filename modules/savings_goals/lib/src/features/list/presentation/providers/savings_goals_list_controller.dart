import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:savings_goals/src/core/domain/entities/savings_goal.dart';
import 'package:savings_goals/src/core/providers/core_providers.dart';

part 'savings_goals_list_controller.g.dart';

@riverpod
class SavingsGoalsListController extends _$SavingsGoalsListController {
  @override
  FutureOr<List<SavingsGoal>> build(String childId) {
    final repository = ref.watch(savingsGoalsRepositoryProvider);
    return repository.getGoals(childId);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    ref.invalidateSelf();
    await future;
  }

  Future<void> deleteGoal(String goalId) async {
    final previousState = state;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(savingsGoalsRepositoryProvider);
      await repository.deleteGoal(goalId);
      final cachedGoals = previousState.asData?.value;
      final goals = [...(cachedGoals ?? await repository.getGoals(childId))];
      goals.removeWhere((goal) => goal.id == goalId);
      return goals;
    });
  }
}
