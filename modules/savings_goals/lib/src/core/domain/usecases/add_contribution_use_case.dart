import 'package:savings_goals/src/core/domain/entities/savings_goal.dart';
import 'package:savings_goals/src/core/domain/exceptions/savings_goal_target_reached_exception.dart';
import 'package:savings_goals/src/core/domain/repositories/saving_goals_repository.dart';

class AddContributionUseCase {
  AddContributionUseCase(this._repository);

  final SavingsGoalsRepository _repository;

  Future<SavingsGoal> call({
    required String goalId,
    required SavingsGoal previousGoal,
    required double targetAmount,
    required double contributionAmount,
  }) async {
    if (previousGoal.currentAmount >= targetAmount) {
      throw const SavingsGoalTargetReachedException(
        message: 'Savings goal target already reached',
      );
    }
    final updatedAmount = previousGoal.currentAmount + contributionAmount;
    await _repository.updateProgress(goalId, updatedAmount);
    return previousGoal.copyWith(currentAmount: updatedAmount);
  }
}
