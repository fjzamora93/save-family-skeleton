import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:home/src/features/home/domain/entities/child_summary.dart';
import 'package:home/src/features/home/domain/entities/home_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:savings_goals/savings_goals.dart';

part 'home_controller.g.dart';

@riverpod
class HomeController extends _$HomeController {
  @override
  FutureOr<HomeData> build() async {
    final repository = ref.watch(savingsGoalsRepositoryProvider);
    final ids = ['child-1', 'child-2'];

    final childrenFutures = ids.map((id) async {
      final goals = await repository.getGoals(id);
      return ChildSummary(
        id: id,
        name: id == 'child-1' ? 'Lucia' : 'Mateo',
        goals: goals,
      );
    }).toList();

    final childrenSummaries = await Future.wait(childrenFutures);
    debugPrint('childrenSummaries: ${childrenSummaries.toString()}');

    return HomeData(
      children: childrenSummaries,
      loadedAt: DateTime.now(),
    );

  
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }
}