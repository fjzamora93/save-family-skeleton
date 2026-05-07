import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:savings_goals/savings_goals.dart';

part 'child_summary.freezed.dart';

@freezed
sealed class ChildSummary with _$ChildSummary {
  const factory ChildSummary({
    required String id,
    required String name,
    required List<SavingsGoal> goals,
  }) = _ChildSummary;
}