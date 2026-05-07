import 'package:flutter/material.dart';
import 'package:localizations/localizations.dart';

Future<void> showSuccessDialog(BuildContext context, String i18nKey) async {
  await showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(ctx.translate(I18n.success)),
      content: Text(ctx.translate(i18nKey)),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(),
          child: Text(ctx.translate(I18n.confirm)),
        ),
      ],
    ),
  );
}
