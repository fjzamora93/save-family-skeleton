import 'package:freezed_annotation/freezed_annotation.dart';

part 'savings_goal.freezed.dart';

@freezed
sealed class SavingsGoal with _$SavingsGoal {
  const factory SavingsGoal({
    required String id,
    required String name,
    required double targetAmount,
    required double currentAmount,
    String? description,
  }) = _SavingsGoal;


  const SavingsGoal._();

  double get progress => targetAmount > 0 ? currentAmount / targetAmount : 0.0;

  double get progressPercent => targetAmount > 0
      ? (currentAmount / targetAmount).clamp(0.0, 1.0).toDouble()
      : 0.0;

  bool get isCompleted => currentAmount >= targetAmount;
}