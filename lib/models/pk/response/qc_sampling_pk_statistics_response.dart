import 'package:json_annotation/json_annotation.dart';

part 'qc_sampling_pk_statistics_response.g.dart';

@JsonSerializable()
class QcSamplingPkStatisticsResponse {
  final bool success;
  final String message;
  final QcSamplingPkStatisticsData? data;

  QcSamplingPkStatisticsResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory QcSamplingPkStatisticsResponse.fromJson(Map<String, dynamic> json)
      => _$QcSamplingPkStatisticsResponseFromJson(json);
}

@JsonSerializable()
class QcSamplingPkStatisticsData {
  final QcSamplingPkPeriod? period;
  final QcSamplingPkStatistics? statistics;

  QcSamplingPkStatisticsData({this.period, this.statistics});

  factory QcSamplingPkStatisticsData.fromJson(Map<String, dynamic> json)
      => _$QcSamplingPkStatisticsDataFromJson(json);
}

@JsonSerializable()
class QcSamplingPkPeriod {
  final String? from;
  final String? to;

  QcSamplingPkPeriod({this.from, this.to});

  factory QcSamplingPkPeriod.fromJson(Map<String, dynamic> json)
      => _$QcSamplingPkPeriodFromJson(json);
}

@JsonSerializable()
class QcSamplingPkStatistics {
  final int total_truk_masuk;
  final int truk_belum_ambil_sample;
  final int truk_sudah_ambil_sample;
  final int total_truk_keluar;

  QcSamplingPkStatistics({
    required this.total_truk_masuk,
    required this.truk_belum_ambil_sample,
    required this.truk_sudah_ambil_sample,
    required this.total_truk_keluar,
  });

  factory QcSamplingPkStatistics.fromJson(Map<String, dynamic> json)
      => _$QcSamplingPkStatisticsFromJson(json);
}