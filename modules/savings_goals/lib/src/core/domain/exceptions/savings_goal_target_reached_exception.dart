import 'package:localizations/localizations.dart';
import 'package:sf_shared/sf_shared.dart';

class SavingsGoalTargetReachedException
    implements DomainException {
  const SavingsGoalTargetReachedException({
    required this.message,
  });

  final String message;

  @override
  String get localizationKey => I18n.errorSavingsGoalTargetReached;

  @override
  String toString() => 'SavingsGoalTargetReachedException: $message';
}
