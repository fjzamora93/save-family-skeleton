import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:navigation/navigation.dart';
import 'package:savings_goals/src/features/list/presentation/savings_goals_list_screen.dart';

class SavingsGoalsListBuilder {
  const SavingsGoalsListBuilder({required this.childId});

  final String childId;

  Page<void> buildPage(BuildContext context, GoRouterState state) {
    final navigationContract = GetIt.I<NavigationContract>();
    return MaterialPage<void>(
      key: state.pageKey,
      child: SavingsGoalsListScreen(
        childId: childId,
        navigationContract: navigationContract,
      ),
    );
  }
}
