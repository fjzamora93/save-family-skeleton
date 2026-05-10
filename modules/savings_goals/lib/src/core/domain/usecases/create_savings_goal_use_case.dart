import 'package:savings_goals/src/core/domain/repositories/saving_goals_repository.dart';

class CreateSavingsGoalUseCase {
  CreateSavingsGoalUseCase(this._repository);

  final SavingsGoalsRepository _repository;

  Future<void> call({
    required String childId,
    required String name,
    required double targetAmount,
    String? description,
  }) {
    return _repository.createGoal(childId, name, targetAmount, description);
  }
}
