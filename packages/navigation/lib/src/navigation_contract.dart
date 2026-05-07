import 'package:go_router/go_router.dart';

abstract class NavigationContract {
  void setRouter(GoRouter goRouter);
  void goTo(String path);
  void pushTo(String path, {Object? extra});
  void goBack();
}

class Navigation implements NavigationContract {
  GoRouter? _router;

  @override
  void setRouter(GoRouter goRouter) {
    _router = goRouter;
  }

  @override
  void goTo(String path) {
    _router?.go(path);
  }

  @override
  void pushTo(String path, {Object? extra}) {
    _router?.push(path, extra: extra);
  }

  @override
  void goBack() {
    final router = _router;
    if (router != null && router.canPop()) {
      router.pop();
    }
  }
}
