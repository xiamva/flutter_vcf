import 'package:json_annotation/json_annotation.dart';
part 'unloading_cpo_statistics_response.g.dart';

@JsonSerializable()
class UnloadingCpoStatisticsResponse {
  final bool success;
  final String message;
  final UnloadingStatisticsData? data;

  UnloadingCpoStatisticsResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory UnloadingCpoStatisticsResponse.fromJson(Map<String, dynamic> json)
    => _$UnloadingCpoStatisticsResponseFromJson(json);
}

@JsonSerializable()
class UnloadingStatisticsData {
  final UnloadingPeriod? period;
  final UnloadingStatistics? statistics;

  UnloadingStatisticsData({
    this.period,
    this.statistics,
  });

  factory UnloadingStatisticsData.fromJson(Map<String, dynamic> json)
    => _$UnloadingStatisticsDataFromJson(json);
}

@JsonSerializable()
class UnloadingPeriod {
  final String? from;
  final String? to;

  UnloadingPeriod({this.from, this.to});

  factory UnloadingPeriod.fromJson(Map<String, dynamic> json)
    => _$UnloadingPeriodFromJson(json);
}

@JsonSerializable()
class UnloadingStatistics {
  final int total_truk_masuk;
  final int truk_belum_unloading;
  final int truk_sudah_unloading;
  final int total_truk_keluar;

  UnloadingStatistics({
    required this.total_truk_masuk,
    required this.truk_belum_unloading,
    required this.truk_sudah_unloading,
    required this.total_truk_keluar,
  });

  factory UnloadingStatistics.fromJson(Map<String, dynamic> json)
    => _$UnloadingStatisticsFromJson(json);
}
