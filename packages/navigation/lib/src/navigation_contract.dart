import 'package:go_router/go_router.dart';
import 'package:navigation/src/app_routes.dart';

abstract class NavigationContract {
  void setRouter(GoRouter goRouter);
  void goTo(String path);
  void pushTo(String path, {Object? extra});
  void goBack();

  
  void navigateToGoalList(String childId);
  void navigateToNewGoal(String childId);
  void navigateToGoalDetail(String childId, String goalId);

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
  void navigateToGoalList(String childId) {
    pushTo('${AppRoutes.home}/children/$childId/savings-goals');
  }

  @override
  void navigateToNewGoal(String childId) {
    pushTo('${AppRoutes.home}/children/$childId/savings-goals/new');
  }

  @override
  void navigateToGoalDetail(String childId, String goalId) {
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
