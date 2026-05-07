import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:home/src/features/home/domain/entities/child_summary.dart';

part 'home_data.freezed.dart';

@freezed
sealed class HomeData with _$HomeData {
  const factory HomeData({
    required List<ChildSummary> children,
    required DateTime loadedAt,
  }) = _HomeData;
}


