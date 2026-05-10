import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:savings_goals/src/core/domain/usecases/savings_goal_use_cases.dart';
import 'package:savings_goals/src/core/providers/core_providers.dart';
import 'package:savings_goals/src/features/create/presentation/providers/create_savings_goal_form_state_provider.dart';
import 'package:savings_goals/src/features/list/presentation/providers/savings_goals_list_controller.dart';

part 'create_savings_goal_controller.g.dart';

@riverpod
class CreateSavingsGoalController extends _$CreateSavingsGoalController {
  late SavingsGoalUseCases _useCases;

  @override
  FutureOr<void> build() {
    _useCases = ref.watch(savingsGoalUseCasesProvider);
  }

  Future<void> submit(String childId) async {
    final formController = ref.read(
      createSavingsGoalFormStateControllerProvider.notifier,
    );
    final formState = ref.read(createSavingsGoalFormStateControllerProvider);
    final isValid = formController.validateAll();
    if (!isValid) {
      return;
    }

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _useCases.createSavingsGoal(
        childId: childId,
        name: formState.name.trim(),
        targetAmount: formState.parsedTargetAmount!,
        description: formState.description.trim().isEmpty
            ? null
            : formState.description.trim(),
      );
    });

    ref.invalidate(savingsGoalsListControllerProvider(childId));

  }
}
