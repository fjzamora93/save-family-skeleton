import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_savings_goal_form_state.freezed.dart';

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
