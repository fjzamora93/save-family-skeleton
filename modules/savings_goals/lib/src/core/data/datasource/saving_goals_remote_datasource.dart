import 'package:savings_goals/src/core/data/models/savings_goal_dto.dart';


abstract class SavingsGoalsRemoteDatasource {
  Future<List<SavingsGoalDto>> fetchGoals(String childId);
  Future<void> createGoal(String childId, Map<String, dynamic> request);
  Future<void> updateProgress(String goalId, double amount);
  Future<void> deleteGoal(String goalId);
}