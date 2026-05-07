import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home/home.dart';
import 'package:sf_shared/testing.dart';

void main() {
  group('HomeController', () {
    test('build resolves with goals for each child', () async {
      final container = makeContainer();
      addTearDown(container.dispose);

      final sub = container.listen(homeControllerProvider, (_, __) {});
      addTearDown(sub.close);

      final data = await container.read(homeControllerProvider.future);

      expect(data.children, hasLength(2));
      expect(data.children[0].goals, hasLength(1));
      expect(data.children[1].goals, hasLength(1));
    });

    test('refresh reloads and exposes AsyncData', () async {
      final container = makeContainer();
      addTearDown(container.dispose);

      final sub = container.listen(homeControllerProvider, (_, __) {});
      addTearDown(sub.close);

      await container.read(homeControllerProvider.future);
      await container.read(homeControllerProvider.notifier).refresh();

      final state = container.read(homeControllerProvider);
      expect(state, isA<AsyncData<HomeData>>());
      expect(state.value?.children, hasLength(2));
    });
  });
}
