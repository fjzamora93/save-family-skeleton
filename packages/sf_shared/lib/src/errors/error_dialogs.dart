import 'package:flutter/material.dart';
import 'package:localizations/localizations.dart';

Future<void> showErrorDialog(
  BuildContext context,
  String i18nKey, {
  String? rawMessage,
}) async {
  await showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(ctx.translate(I18n.error)),
      content: Text(rawMessage ?? ctx.translate(i18nKey)),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(),
          child: Text(ctx.translate(I18n.confirm)),
        ),
      ],
    ),
  );
}

Future<void> showOfflineDialog(
  BuildContext context, {
  VoidCallback? onRetry,
}) async {
  await showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(ctx.translate(I18n.errorConnectionTitle)),
      content: Text(ctx.translate(I18n.errorConnection)),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(),
          child: Text(ctx.translate(I18n.cancel)),
        ),
        if (onRetry != null)
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              onRetry();
            },
            child: Text(ctx.translate(I18n.retry)),
          ),
      ],
    ),
  );
}
