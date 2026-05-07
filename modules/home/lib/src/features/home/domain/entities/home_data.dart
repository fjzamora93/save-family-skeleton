import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_data.freezed.dart';

@freezed
abstract class HomeData with _$HomeData {
  const factory HomeData({
    required int counter,
    required DateTime loadedAt,
  }) = _HomeData;
}
