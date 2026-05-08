import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:navigation/navigation.dart';
import 'package:savings_goals/src/features/detail/presentation/saving_goal_detail_screen.dart';

class SavingsGoalDetailBuilder {
  const SavingsGoalDetailBuilder({
    required this.childId,
    required this.goalId,
  });

  final String childId;
  final String goalId;

  Page<void> buildPage(BuildContext context, GoRouterState state) {
    final navigationContract = GetIt.I<NavigationContract>();
    return MaterialPage<void>(
      key: state.pageKey,
      child: SavingGoalDetailScreen(
        childId: childId,
        goalId: goalId,
        navigationContract: navigationContract,
      ),
    );
  }
}
