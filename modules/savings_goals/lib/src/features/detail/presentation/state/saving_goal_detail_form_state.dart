import 'package:freezed_annotation/freezed_annotation.dart';

part 'saving_goal_detail_form_state.freezed.dart';

@freezed
sealed class SavingGoalDetailFormState with _$SavingGoalDetailFormState {
  const factory SavingGoalDetailFormState({
    @Default('') String contributionAmount,
    String? contributionErrorKey,
  }) = _SavingGoalDetailFormState;

  const SavingGoalDetailFormState._();

  double? get parsedContributionAmount {
    final normalized = contributionAmount.trim().replaceAll(',', '.');
    if (normalized.isEmpty) {
      return null;
    }
    final amount = double.tryParse(normalized);
    if (amount == null || amount <= 0) {
      return null;
    }
    return amount;
  }
}
