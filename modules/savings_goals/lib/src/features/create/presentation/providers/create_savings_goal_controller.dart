import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:savings_goals/src/core/providers/core_providers.dart';
import 'package:savings_goals/src/core/providers/savings_goal_form_state_provider.dart';

part 'create_savings_goal_controller.g.dart';

@riverpod
class CreateSavingsGoalController extends _$CreateSavingsGoalController {
  @override
  FutureOr<void> build() {}

  Future<void> submit(String childId) async {
    final formController = ref.read(
      savingsGoalFormStateControllerProvider(SavingsGoalFormScopes.create).notifier,
    );
    final formState = ref.read(
      savingsGoalFormStateControllerProvider(SavingsGoalFormScopes.create),
    );
    final isValid = formController.validateAllCreate();
    if (!isValid) {
      return;
    }

    final repository = ref.read(savingsGoalsRepositoryProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await repository.createGoal(
        childId,
        formState.name.trim(),
        formState.parsedTargetAmount!,
        formState.description.trim().isEmpty ? null : formState.description.trim(),
      );
    });
  }
}
