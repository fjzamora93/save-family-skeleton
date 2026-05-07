import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:navigation/navigation.dart';
import 'package:savings_goals/src/features/create/presentation/create_savings_goal_screen.dart';

class CreateSavingsGoalBuilder {
  const CreateSavingsGoalBuilder({required this.childId});

  final String childId;

  Page<void> buildPage(BuildContext context, GoRouterState state) {
    final navigationContract = GetIt.I<NavigationContract>();
    return MaterialPage<void>(
      key: state.pageKey,
      child: CreateSavingsGoalScreen(
        childId: childId,
        navigationContract: navigationContract,
      ),
    );
  }
}
