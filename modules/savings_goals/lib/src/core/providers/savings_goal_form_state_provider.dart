import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:savings_goals/src/core/domain/validator/savings_goal_form_validator.dart';

part 'savings_goal_form_state_provider.freezed.dart';
part 'savings_goal_form_state_provider.g.dart';

abstract final class SavingsGoalFormScopes {
  static const create = 'sf_form_create';

  static String detail(String childId, String goalId) =>
      'sf_form_detail::$childId::$goalId';
}

@freezed
sealed class SavingsGoalFormState with _$SavingsGoalFormState {
  const factory SavingsGoalFormState({
    @Default('') String name,
    @Default('') String targetAmount,
    @Default('') String description,
    @Default('') String contributionAmount,
    String? nameErrorKey,
    String? targetAmountErrorKey,
    String? contributionErrorKey,
  }) = _SavingsGoalFormState;

  const SavingsGoalFormState._();

  double? get parsedTargetAmount =>
      double.tryParse(targetAmount.trim().replaceAll(',', '.'));

  double? get parsedContributionAmount {
    final trimmed = contributionAmount.trim();
    if (trimmed.isEmpty) return null;
    if (SavingsGoalFormValidator.validateContribution(contributionAmount) != null) {
      return null;
    }
    return double.tryParse(trimmed.replaceAll(',', '.'));
  }

  bool get isValidCreate =>
      nameErrorKey == null &&
      targetAmountErrorKey == null &&
      name.trim().isNotEmpty &&
      parsedTargetAmount != null;

  bool get isValidContribution =>
      contributionErrorKey == null &&
      contributionAmount.trim().isNotEmpty &&
      SavingsGoalFormValidator.validateContribution(contributionAmount) == null;
}

@riverpod
class SavingsGoalFormStateController extends _$SavingsGoalFormStateController {
  @override
  SavingsGoalFormState build(String scope) {
    return const SavingsGoalFormState();
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

  void updateContributionAmount(String value) {
    state = state.copyWith(
      contributionAmount: value,
      contributionErrorKey: SavingsGoalFormValidator.validateContribution(value),
    );
  }

  bool validateAllCreate() {
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
