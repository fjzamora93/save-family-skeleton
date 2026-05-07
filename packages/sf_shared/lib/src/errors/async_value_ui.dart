import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'failure_type.dart';
import 'handle_failure.dart';

extension AsyncValueUI<T> on AsyncValue<T> {
  Future<void> showErrorOn(
    BuildContext context, {
    VoidCallback? onRetry,
  }) async {
    if (isLoading || !hasError) return;
    await handleFailure(
      context: context,
      failureType: FailureType.fromException(error),
      error: error,
      onRetry: onRetry,
    );
  }
}
