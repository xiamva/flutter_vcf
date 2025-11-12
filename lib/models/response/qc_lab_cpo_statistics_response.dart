import 'package:json_annotation/json_annotation.dart';
part 'qc_lab_cpo_statistics_response.g.dart';

@JsonSerializable()
class QcLabCpoStatisticsResponse {
  final bool success;
  final String message;
  final QcLabCpoStatisticsData? data;

  QcLabCpoStatisticsResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory QcLabCpoStatisticsResponse.fromJson(Map<String, dynamic> json)
      => _$QcLabCpoStatisticsResponseFromJson(json);
}

@JsonSerializable()
class QcLabCpoStatisticsData {
  final QcLabCpoPeriod? period;
  final QcLabCpoStats? statistics;

  QcLabCpoStatisticsData({
    this.period,
    this.statistics,
  });

  factory QcLabCpoStatisticsData.fromJson(Map<String, dynamic> json)
      => _$QcLabCpoStatisticsDataFromJson(json);
}

@JsonSerializable()
class QcLabCpoPeriod {
  final String? from;
  final String? to;

  QcLabCpoPeriod({this.from, this.to});

  factory QcLabCpoPeriod.fromJson(Map<String, dynamic> json)
      => _$QcLabCpoPeriodFromJson(json);
}

@JsonSerializable()
class QcLabCpoStats {
  final int total_truk_masuk;
  final int truk_belum_cek_lab;
  final int truk_sudah_cek_lab;
  final int total_truk_keluar;

  QcLabCpoStats({
    required this.total_truk_masuk,
    required this.truk_belum_cek_lab,
    required this.truk_sudah_cek_lab,
    required this.total_truk_keluar,
  });

  factory QcLabCpoStats.fromJson(Map<String, dynamic> json)
      => _$QcLabCpoStatsFromJson(json);
}
