import 'package:design_system/src/theme/theme_module.dart';
import 'package:design_system/src/theme/theme_port.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SfNumberInput extends ConsumerWidget {
  const SfNumberInput({
    super.key,
    required this.label,
    this.controller,
    this.errorText,
    this.hintText,
    this.textInputAction,
    this.onChanged,
  });

  final String label;
  final TextEditingController? controller;
  final String? errorText;
  final String? hintText;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themePortProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: theme.colorFor(ThemeCode.textPrimary),
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          onChanged: onChanged,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          textInputAction: textInputAction,
          inputFormatters: const [_DigitsOnlyDecimalFormatter()],
          decoration: InputDecoration(
            hintText: hintText,
            errorText: errorText,
            counterText: '',
            filled: true,
            fillColor: theme.colorFor(ThemeCode.backgroundSecondary),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: theme.colorFor(ThemeCode.border)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: theme.colorFor(ThemeCode.border)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: theme.colorFor(ThemeCode.buttonPrimary),
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: theme.colorFor(ThemeCode.error)),
            ),
          ),
        ),
      ],
    );
  }
}

class _DigitsOnlyDecimalFormatter extends TextInputFormatter {
  const _DigitsOnlyDecimalFormatter();

  static final RegExp _pattern = RegExp(r'^[0-9]*[.,]?[0-9]*$');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) return newValue;
    if (_pattern.hasMatch(newValue.text)) return newValue;
    return oldValue;
  }
}
