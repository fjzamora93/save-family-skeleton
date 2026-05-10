import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:savings_goals/src/core/domain/validator/savings_goal_form_validator.dart';
import 'package:savings_goals/src/features/create/presentation/state/create_savings_goal_form_state.dart';

part 'create_savings_goal_form_state_provider.g.dart';

@riverpod
class CreateSavingsGoalFormStateController
    extends _$CreateSavingsGoalFormStateController {
  @override
  CreateSavingsGoalFormState build() {
    return const CreateSavingsGoalFormState(
      name: '',
      targetAmount: '',
      description: '',
    );
  }

  void updateName(String value) {
    state = state.copyWith(
      name: value,
      nameErrorKey: SavingsGoalFormValidator.validateName(value),
    );
  }

  void updateTargetAmount(String value) {
    state = state.copyWith(
      targetAmount: value,
      targetAmountErrorKey:
          SavingsGoalFormValidator.validateTargetAmount(value),
    );
  }

  void updateDescription(String value) {
    state = state.copyWith(description: value);
  }

  bool validateAll() {
    final nameError = SavingsGoalFormValidator.validateName(state.name);
    final targetAmountError = SavingsGoalFormValidator.validateTargetAmount(
      state.targetAmount,
    );
    state = state.copyWith(
      nameErrorKey: nameError,
      targetAmountErrorKey: targetAmountError,
    );
    return nameError == null && targetAmountError == null;
  }
}
