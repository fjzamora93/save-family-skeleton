import 'package:savings_goals/src/core/domain/entities/savings_goal.dart';
import 'package:savings_goals/src/core/domain/repositories/saving_goals_repository.dart';

class GetSavingsGoalByIdUseCase {
  GetSavingsGoalByIdUseCase(this._repository);

  final SavingsGoalsRepository _repository;

  Future<SavingsGoal> call({
    required String childId,
    required String goalId,
  }) {
    return _repository.getGoalById(childId, goalId);
  }
}
