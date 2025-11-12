import 'package:json_annotation/json_annotation.dart';

part 'unloading_pome_statistics_response.g.dart';

@JsonSerializable()
class UnloadingPomeStatisticsResponse {
  final bool? success;
  final String? message;
  final UnloadingPomeStatisticsData? data;

  UnloadingPomeStatisticsResponse({
    this.success,
    this.message,
    this.data,
  });

  factory UnloadingPomeStatisticsResponse.fromJson(Map<String, dynamic> json) =>
      _$UnloadingPomeStatisticsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UnloadingPomeStatisticsResponseToJson(this);
}

@JsonSerializable()
class UnloadingPomeStatisticsData {
  final UnloadingPomeStatistics? statistics;

  UnloadingPomeStatisticsData({this.statistics});

  factory UnloadingPomeStatisticsData.fromJson(Map<String, dynamic> json) =>
      _$UnloadingPomeStatisticsDataFromJson(json);

  Map<String, dynamic> toJson() => _$UnloadingPomeStatisticsDataToJson(this);
}

@JsonSerializable()
class UnloadingPomeStatistics {
  @JsonKey(defaultValue: 0)
  final int total_truk_masuk;

  @JsonKey(defaultValue: 0)
  final int truk_belum_unloading;

  @JsonKey(defaultValue: 0)
  final int truk_sudah_unloading;

  @JsonKey(defaultValue: 0)
  final int total_truk_keluar;

  UnloadingPomeStatistics({
    required this.total_truk_masuk,
    required this.truk_belum_unloading,
    required this.truk_sudah_unloading,
    required this.total_truk_keluar,
  });

  factory UnloadingPomeStatistics.fromJson(Map<String, dynamic> json) =>
      _$UnloadingPomeStatisticsFromJson(json);

  Map<String, dynamic> toJson() => _$UnloadingPomeStatisticsToJson(this);
}
