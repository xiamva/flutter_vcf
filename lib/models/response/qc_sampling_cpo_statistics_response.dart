import 'package:json_annotation/json_annotation.dart';

part 'qc_sampling_cpo_statistics_response.g.dart';

@JsonSerializable()
class QcSamplingCpoStatisticsResponse {
  final bool success;
  final String message;
  final QcSamplingStatisticsData? data;

  QcSamplingCpoStatisticsResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory QcSamplingCpoStatisticsResponse.fromJson(Map<String, dynamic> json)
      => _$QcSamplingCpoStatisticsResponseFromJson(json);
}

@JsonSerializable()
class QcSamplingStatisticsData {
  final QcSamplingPeriod? period;
  final QcSamplingStatistics? statistics;

  QcSamplingStatisticsData({this.period, this.statistics});

  factory QcSamplingStatisticsData.fromJson(Map<String, dynamic> json)
      => _$QcSamplingStatisticsDataFromJson(json);
}

@JsonSerializable()
class QcSamplingPeriod {
  final String? from;
  final String? to;

  QcSamplingPeriod({this.from, this.to});

  factory QcSamplingPeriod.fromJson(Map<String, dynamic> json)
      => _$QcSamplingPeriodFromJson(json);
}

@JsonSerializable()
class QcSamplingStatistics {
  final int total_truk_masuk;
  final int truk_belum_ambil_sample;
  final int truk_sudah_ambil_sample;
  final int total_truk_keluar;

  QcSamplingStatistics({
    required this.total_truk_masuk,
    required this.truk_belum_ambil_sample,
    required this.truk_sudah_ambil_sample,
    required this.total_truk_keluar,
  });

  factory QcSamplingStatistics.fromJson(Map<String, dynamic> json)
      => _$QcSamplingStatisticsFromJson(json);
}
