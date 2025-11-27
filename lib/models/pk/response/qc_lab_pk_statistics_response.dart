import 'package:json_annotation/json_annotation.dart';

part 'qc_lab_pk_statistics_response.g.dart';

@JsonSerializable()
class QcLabPkStatisticsResponse {
  final bool? success;
  final String? message;
  final QcLabPkStatisticsData? data;

  QcLabPkStatisticsResponse({
    this.success,
    this.message,
    this.data,
  });

  factory QcLabPkStatisticsResponse.fromJson(Map<String, dynamic> json) =>
      _$QcLabPkStatisticsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$QcLabPkStatisticsResponseToJson(this);
}

@JsonSerializable()
class QcLabPkStatisticsData {
  final QcLabPkStatistics? statistics;

  QcLabPkStatisticsData({this.statistics});

  factory QcLabPkStatisticsData.fromJson(Map<String, dynamic> json) =>
      _$QcLabPkStatisticsDataFromJson(json);

  Map<String, dynamic> toJson() => _$QcLabPkStatisticsDataToJson(this);
}

@JsonSerializable()
class QcLabPkStatistics {
  @JsonKey(name: 'total_truk_masuk')
  final int? total_truk_masuk;

  @JsonKey(name: 'truk_belum_cek_lab')
  final int? truk_belum_cek_lab;

  @JsonKey(name: 'truk_sudah_cek_lab')
  final int? truk_sudah_cek_lab;

  @JsonKey(name: 'total_truk_keluar')
  final int? total_truk_keluar;

  QcLabPkStatistics({
    this.total_truk_masuk,
    this.truk_belum_cek_lab,
    this.truk_sudah_cek_lab,
    this.total_truk_keluar,
  });

  factory QcLabPkStatistics.fromJson(Map<String, dynamic> json) =>
      _$QcLabPkStatisticsFromJson(json);

  Map<String, dynamic> toJson() => _$QcLabPkStatisticsToJson(this);
}

