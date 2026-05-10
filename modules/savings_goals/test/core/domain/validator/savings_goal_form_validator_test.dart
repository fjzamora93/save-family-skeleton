import 'package:flutter_test/flutter_test.dart';
import 'package:localizations/localizations.dart';
import 'package:savings_goals/src/core/domain/validator/savings_goal_form_validator.dart';

void main() {
  group('SavingsGoalFormValidator', () {
    test('validateName returns error for short name and null for valid name', () {
      expect(
        SavingsGoalFormValidator.validateName('ab'),
        I18n.savingsGoalValidationNameLength,
      );
      expect(
        SavingsGoalFormValidator.validateName('Ana'),
        isNull,
      );
    });

    test(
        'validateTargetAmount returns error for invalid amount and null for valid', () {
      expect(
        SavingsGoalFormValidator.validateTargetAmount('0'),
        I18n.savingsGoalValidationTargetAmount,
      );
      expect(
        SavingsGoalFormValidator.validateTargetAmount('100'),
        isNull,
      );
    });
  });
}
