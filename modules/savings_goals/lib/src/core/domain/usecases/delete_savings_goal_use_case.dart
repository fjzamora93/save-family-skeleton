import 'package:savings_goals/src/core/domain/repositories/saving_goals_repository.dart';

class DeleteSavingsGoalUseCase {
  DeleteSavingsGoalUseCase(this._repository);

  final SavingsGoalsRepository _repository;

  Future<void> call({required String goalId}) {
    return _repository.deleteGoal(goalId);
  }
}
