import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:savings_goals/src/core/data/datasource/saving_goals_remote_datasource.dart';
import 'package:savings_goals/src/core/data/models/savings_goal_dto.dart';
import 'package:savings_goals/src/core/data/repositories/saving_goals_repository_impl.dart';
import 'package:savings_goals/src/core/domain/entities/savings_goal.dart';
import 'package:sf_shared/sf_shared.dart';

class _MockDatasource extends Mock implements SavingsGoalsRemoteDatasource {}

void main() {
  late _MockDatasource datasource;
  late SavingsGoalsRepositoryImpl repository;

  setUp(() {
    datasource = _MockDatasource();
    repository = SavingsGoalsRepositoryImpl(datasource);
  });

  group('SavingsGoalsRepositoryImpl', () {
    test('getGoals maps datasource DTOs to domain entities', () async {
      when(() => datasource.fetchGoals('child-1')).thenAnswer(
        (_) async => [
          SavingsGoalDto(
            id: 'g1',
            name: 'Bici',
            targetAmount: 120,
            currentAmount: 45,
            description: null,
          ),
        ],
      );

      final goals = await repository.getGoals('child-1');

      expect(
        goals,
        [
          const SavingsGoal(
            id: 'g1',
            name: 'Bici',
            targetAmount: 120,
            currentAmount: 45,
            description: null,
          ),
        ],
      );
    });

    test('createGoal rethrows ApiException with statusCode 409', () async {
      when(() => datasource.createGoal(any(), any())).thenThrow(
        const ApiException(
          message: 'Goal name already exists',
          statusCode: 409,
        ),
      );

      await expectLater(
        () => repository.createGoal('child-1', 'Dup', 10, null),
        throwsA(
          isA<ApiException>().having(
            (e) => e.statusCode,
            'statusCode',
            409,
          ),
        ),
      );
    });
  });
}
