import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:savings_goals/savings_goals.dart';

part 'child_summary.freezed.dart';

@freezed
sealed class ChildSummary with _$ChildSummary {

  const ChildSummary._();
  
  const factory ChildSummary({
    required String id,
    required String name,
    required List<SavingsGoal> goals,
  }) = _ChildSummary;


  double get totalTarget => goals.fold(0.0, (sum, g) => sum + g.targetAmount);
  double get totalCurrent => goals.fold(0.0, (sum, g) => sum + g.currentAmount);
  double get totalProgress => totalTarget > 0 ? totalCurrent / totalTarget : 0.0;
  
  String get targetStr => totalTarget.toStringAsFixed(2);
  String get currentStr => totalCurrent.toStringAsFixed(2);
}