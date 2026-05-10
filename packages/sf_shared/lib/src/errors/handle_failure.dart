import 'package:flutter/material.dart';
import 'package:localizations/localizations.dart';

import 'api_exception.dart';
import 'error_dialogs.dart';
import 'failure_type.dart';
import 'domain_exception.dart';

bool _dialogOpen = false;

@visibleForTesting
void resetDialogOpenFlag() {
  _dialogOpen = false;
}

Future<void> handleFailure({
  required BuildContext context,
  required FailureType failureType,
  Object? error,
  VoidCallback? onRetry,
}) async {
  if (_dialogOpen) return;
  _dialogOpen = true;
  try {
    switch (failureType) {
      case FailureType.connection:
        await showOfflineDialog(context, onRetry: onRetry);
      case FailureType.technical || FailureType.other:
        await showErrorDialog(context, I18n.errorTechnical);
      case FailureType.notAuthorized:
        await showErrorDialog(context, I18n.errorNotAuthorized);
      case FailureType.notFound:
        await showErrorDialog(context, I18n.errorNotFound);
      case FailureType.validation:
        await showErrorDialog(context, I18n.errorValidation);
      case FailureType.rateLimit:
        await showErrorDialog(context, I18n.errorRateLimit);
      case FailureType.conflict:
        final raw = error is ApiException ? error.message : null;
        await showErrorDialog(context, I18n.errorConflict, rawMessage: raw);
      case FailureType.userFacingDomain:
        final key = error is DomainException
            ? error.localizationKey
            : I18n.errorTechnical;
        await showErrorDialog(context, key);
    }
  } finally {
    _dialogOpen = false;
  }
}
