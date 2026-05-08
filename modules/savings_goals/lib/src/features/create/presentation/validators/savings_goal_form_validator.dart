import 'package:localizations/src/generated/i18n.dart';

class SavingsGoalFormValidator {
  static String? validateName(String value) {
    final trimmed = value.trim();
    if (trimmed.length < 3 || trimmed.length > 40) {
      return I18n.savingsGoalValidationNameLength;
    }
    return null;
  }

  static String? validateTargetAmount(String value) {
    final normalized = value.trim().replaceAll(',', '.');
    final amount = double.tryParse(normalized);
    if (amount == null || amount <= 0 || amount > 10000) {
      return I18n.savingsGoalValidationTargetAmount;
    }
    return null;
  }
}
