import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:savings_goals/src/core/domain/validator/savings_goal_form_validator.dart';
import 'package:savings_goals/src/features/detail/presentation/state/saving_goal_detail_form_state.dart';

part 'saving_goal_detail_state_provider.g.dart';

@riverpod
class SavingGoalDetailFormStateController
    extends _$SavingGoalDetailFormStateController {
  @override
  SavingGoalDetailFormState build(String childId, String goalId) {
    return const SavingGoalDetailFormState();
  }

  void updateContributionAmount(String value) {
    state = state.copyWith(
      contributionAmount: value,
      contributionErrorKey:
          SavingsGoalFormValidator.validateContribution(value),
    );
  }
}
