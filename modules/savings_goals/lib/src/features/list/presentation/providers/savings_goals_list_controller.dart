import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:savings_goals/src/core/domain/entities/savings_goal.dart';
import 'package:savings_goals/src/core/domain/usecases/savings_goal_use_cases.dart';
import 'package:savings_goals/src/core/providers/core_providers.dart';

part 'savings_goals_list_controller.g.dart';

@riverpod
class SavingsGoalsListController extends _$SavingsGoalsListController {
  late SavingsGoalUseCases _useCases;

  @override
  FutureOr<List<SavingsGoal>> build(String childId) {
    _useCases = ref.watch(savingsGoalUseCasesProvider);
    return _useCases.getGoalsByChild(childId: childId);
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
      await _useCases.deleteSavingsGoal(goalId: goalId);
      final cachedGoals = previousState.asData?.value;
      final goals = [
        ...(cachedGoals ?? await _useCases.getGoalsByChild(childId: childId)),
      ];
      goals.removeWhere((goal) => goal.id == goalId);
      return goals;
    });
  }
}
