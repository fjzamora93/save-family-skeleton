import 'package:savings_goals/src/core/domain/entities/savings_goal.dart';
import 'package:savings_goals/src/core/domain/repositories/saving_goals_repository.dart';

class GetSavingsGoalsByChildUseCase {
  GetSavingsGoalsByChildUseCase(this._repository);

  final SavingsGoalsRepository _repository;

  Future<List<SavingsGoal>> call({required String childId}) {
    return _repository.getGoals(childId);
  }
}
