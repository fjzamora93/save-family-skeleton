import 'package:go_router/go_router.dart';
import 'package:navigation/src/app_routes.dart';

abstract class NavigationContract {
  void setRouter(GoRouter goRouter);
  void goTo(String path);
  void pushTo(String path, {Object? extra});
  void goToList(String childId);
  void goToCreate(String childId);
  void goToDetail(String childId, String goalId);
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
  void goToList(String childId) {
    pushTo('${AppRoutes.home}/children/$childId/savings-goals');
  }

  @override
  void goToCreate(String childId) {
    pushTo('${AppRoutes.home}/children/$childId/savings-goals/new');
  }

  @override
  void goToDetail(String childId, String goalId) {
    pushTo('${AppRoutes.home}/children/$childId/savings-goals/$goalId');
  }

  @override
  void goBack() {
    final router = _router;
    if (router != null && router.canPop()) {
      router.pop();
    }
  }
}
