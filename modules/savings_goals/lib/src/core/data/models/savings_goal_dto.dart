import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/savings_goal.dart';

part 'savings_goal_dto.freezed.dart';
part 'savings_goal_dto.g.dart';

@freezed
sealed class SavingsGoalDto with _$SavingsGoalDto {
  const factory SavingsGoalDto({
    required String id,
    required String name,
    @JsonKey(name: 'target_amount') required double targetAmount,
    @JsonKey(name: 'current_amount') required double currentAmount,
    String? description,
  }) = _SavingsGoalDto;

  factory SavingsGoalDto.fromJson(Map<String, dynamic> json) =>
      _$SavingsGoalDtoFromJson(json);

  // Constructor privado necesario para tener métodos/mapeos dentro
  const SavingsGoalDto._();


  SavingsGoal toEntity() {
    return SavingsGoal(
      id: id,
      name: name,
      targetAmount: targetAmount,
      currentAmount: currentAmount,
      description: description,
    );
  }
}

extension SavingsGoalToDto on SavingsGoal {
  SavingsGoalDto toDto() {
    return SavingsGoalDto(
      id: id,
      name: name,
      targetAmount: targetAmount,
      currentAmount: currentAmount,
      description: description,
    );
  }
}