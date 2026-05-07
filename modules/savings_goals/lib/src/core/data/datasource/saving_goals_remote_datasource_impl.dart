import 'package:savings_goals/src/core/data/datasource/saving_goals_remote_datasource.dart';
import 'package:savings_goals/src/core/data/models/savings_goal_dto.dart';
import 'package:sf_shared/sf_shared.dart';


class SavingsGoalsRemoteDatasourceImpl implements SavingsGoalsRemoteDatasource {


  // TODO: Esto a ver si lo metemos en otro lado.... qué se yo, que no moleste aquí
  final List<Map<String, dynamic>> _storage = [
    {'id': '1', 'childId': 'child-1', 'name': 'Bici', 'target_amount': 120.0, 'current_amount': 45.0},
    {'id': '2', 'childId': 'child-2', 'name': 'Lego', 'target_amount': 50.0, 'current_amount': 10.0},
  ];

  int _updateAttempts = 0;

  @override
  Future<List<SavingsGoalDto>> fetchGoals(String childId) async {
    await Future.delayed(const Duration(milliseconds: 600));
    if (childId == 'child-error') {
      throw ApiException(message: 'Network error', isNetworkError: true);
    }
    return _storage
        .where((item) => item['childId'] == childId)
        .map((item) => SavingsGoalDto.fromJson(item))
        .toList();
  }

  @override
  Future<void> createGoal(String childId, Map<String, dynamic> request) async {
    await Future.delayed(const Duration(milliseconds: 600));
    
    final exists = _storage.any((g) => g['childId'] == childId && g['name'] == request['name']);
    if (exists) {
      throw ApiException(message: 'Goal name already exists', statusCode: 409);
    }

    _storage.add({
      'id': DateTime.now().toString(),
      'childId': childId,
      ...request,
      'current_amount': 0.0,
    });
  }

  @override
  Future<void> updateProgress(String goalId, double amount) async {
    await Future.delayed(const Duration(milliseconds: 600));
    _updateAttempts++;

    if (_updateAttempts % 5 == 0) {
      throw ApiException(message: 'Network error', isNetworkError: true);
    }

    final index = _storage.indexWhere((g) => g['id'] == goalId);
    if (index != -1) _storage[index]['current_amount'] = amount;
  }

  @override
  Future<void> deleteGoal(String goalId) async {
    await Future.delayed(const Duration(milliseconds: 600));
    _storage.removeWhere((g) => g['id'] == goalId);
  }
}