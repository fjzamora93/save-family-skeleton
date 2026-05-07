
import 'package:savings_goals/src/core/domain/entities/savings_goal.dart';

abstract class SavingsGoalsRepository {
  Future<List<SavingsGoal>> getGoals(String childId);
  Future<void> createGoal(String childId, String name, double target, String? desc);
  Future<void> updateProgress(String goalId, double amount);
  Future<void> deleteGoal(String goalId);
}