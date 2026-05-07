import 'package:savings_goals/src/core/data/datasource/saving_goals_remote_datasource.dart';
import 'package:savings_goals/src/core/domain/entities/savings_goal.dart';
import 'package:savings_goals/src/core/domain/repositories/saving_goals_repository.dart';
import 'package:sf_shared/sf_shared.dart';


class SavingsGoalsRepositoryImpl implements SavingsGoalsRepository {
  final SavingsGoalsRemoteDatasource _datasource;
  SavingsGoalsRepositoryImpl(this._datasource);

  @override
  Future<List<SavingsGoal>> getGoals(String childId) async {
    try {
      final dtos = await _datasource.fetchGoals(childId);
      return dtos.map((dto) => dto.toEntity()).toList();
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: e.toString());
    }
  }

  @override
  Future<void> createGoal(String childId, String name, double target, String? desc) async {
    try {
      await _datasource.createGoal(childId, {
        'name': name,
        'target_amount': target,
        'description': desc,
      });
    } on ApiException {
      rethrow;
    }
  }

  @override
  Future<void> updateProgress(String goalId, double amount) async {
    try {
      await _datasource.updateProgress(goalId, amount);
    } on ApiException {
      rethrow;
    }
  }

  @override
  Future<void> deleteGoal(String goalId) async {
    await _datasource.deleteGoal(goalId);
  }
}