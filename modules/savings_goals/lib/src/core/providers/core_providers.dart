import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:savings_goals/src/core/data/datasource/saving_goals_remote_datasource.dart';
import 'package:savings_goals/src/core/data/datasource/saving_goals_remote_datasource_impl.dart';
import 'package:savings_goals/src/core/data/repositories/saving_goals_repository_impl.dart';
import 'package:savings_goals/src/core/domain/repositories/saving_goals_repository.dart';
part 'core_providers.g.dart';



@riverpod
SavingsGoalsRemoteDatasource savingsGoalsDatasource(Ref ref) {
  return SavingsGoalsRemoteDatasourceImpl();
}


@riverpod
SavingsGoalsRepository savingsGoalsRepository(Ref ref) {
  final datasource = ref.watch(savingsGoalsDatasourceProvider);
  return SavingsGoalsRepositoryImpl(datasource);
}