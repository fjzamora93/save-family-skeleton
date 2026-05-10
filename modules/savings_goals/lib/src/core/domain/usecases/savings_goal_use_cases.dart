import 'package:savings_goals/src/core/domain/repositories/saving_goals_repository.dart';
import 'package:savings_goals/src/core/domain/usecases/add_contribution_use_case.dart';
import 'package:savings_goals/src/core/domain/usecases/create_savings_goal_use_case.dart';
import 'package:savings_goals/src/core/domain/usecases/delete_savings_goal_use_case.dart';
import 'package:savings_goals/src/core/domain/usecases/get_savings_goal_by_id_use_case.dart';
import 'package:savings_goals/src/core/domain/usecases/get_savings_goals_by_child_use_case.dart';

class SavingsGoalUseCases {
  SavingsGoalUseCases({required SavingsGoalsRepository repository})
      : createSavingsGoal = CreateSavingsGoalUseCase(repository),
        addContribution = AddContributionUseCase(repository),
        getGoalById = GetSavingsGoalByIdUseCase(repository),
        getGoalsByChild = GetSavingsGoalsByChildUseCase(repository),
        deleteSavingsGoal = DeleteSavingsGoalUseCase(repository);

  final CreateSavingsGoalUseCase createSavingsGoal;
  final AddContributionUseCase addContribution;
  final GetSavingsGoalByIdUseCase getGoalById;
  final GetSavingsGoalsByChildUseCase getGoalsByChild;
  final DeleteSavingsGoalUseCase deleteSavingsGoal;
}
