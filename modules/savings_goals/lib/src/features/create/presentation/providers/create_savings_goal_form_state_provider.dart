import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:savings_goals/src/features/create/presentation/validators/savings_goal_form_validator.dart';

part 'create_savings_goal_form_state_provider.freezed.dart';
part 'create_savings_goal_form_state_provider.g.dart';

@freezed
sealed class CreateSavingsGoalFormState with _$CreateSavingsGoalFormState {
  const factory CreateSavingsGoalFormState({
    required String name,
    required String targetAmount,
    required String description,
    String? nameErrorKey,
    String? targetAmountErrorKey,
  }) = _CreateSavingsGoalFormState;

  const CreateSavingsGoalFormState._();

  double? get parsedTargetAmount =>
      double.tryParse(targetAmount.trim().replaceAll(',', '.'));

  bool get isValid =>
      nameErrorKey == null &&
      targetAmountErrorKey == null &&
      name.trim().isNotEmpty &&
      parsedTargetAmount != null;
}

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
      targetAmountErrorKey: SavingsGoalFormValidator.validateTargetAmount(value),
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
