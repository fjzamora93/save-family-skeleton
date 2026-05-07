import 'dart:async';

import 'package:home/src/features/home/domain/entities/home_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_controller.g.dart';

@riverpod
class HomeController extends _$HomeController {
  @override
  FutureOr<HomeData> build() async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    return HomeData(counter: 0, loadedAt: DateTime.now());
  }

  Future<void> refresh() async {
    final previous = state.value;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await Future<void>.delayed(const Duration(milliseconds: 400));
      return HomeData(
        counter: (previous?.counter ?? 0) + 1,
        loadedAt: DateTime.now(),
      );
    });
  }
}
