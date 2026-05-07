import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:home/src/features/home/presentation/home_screen.dart';
import 'package:navigation/navigation.dart';

class HomeBuilder {
  const HomeBuilder();

  Page<void> buildPage(BuildContext context, GoRouterState state) {
    final navigationContract = GetIt.I<NavigationContract>();
    return MaterialPage<void>(
      key: state.pageKey,
      child: HomeScreen(navigationContract: navigationContract),
    );
  }
}
