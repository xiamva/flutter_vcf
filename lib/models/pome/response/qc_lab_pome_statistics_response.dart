import 'package:json_annotation/json_annotation.dart';

part 'qc_lab_pome_statistics_response.g.dart';

@JsonSerializable()
class QcLabPomeStatisticsResponse {
  final bool success;
  final String? message;
  final PomeLabData? data;

  QcLabPomeStatisticsResponse({
    required this.success,
    this.message,
    this.data,
  });

  factory QcLabPomeStatisticsResponse.fromJson(Map<String, dynamic> json) =>
      _$QcLabPomeStatisticsResponseFromJson(json);
  Map<String, dynamic> toJson() => _$QcLabPomeStatisticsResponseToJson(this);
}

@JsonSerializable()
class PomeLabData {
  final PomeLabPeriod? period;
  final PomeLabStatistics? statistics;

  PomeLabData({this.period, this.statistics});

  factory PomeLabData.fromJson(Map<String, dynamic> json) =>
      _$PomeLabDataFromJson(json);
  Map<String, dynamic> toJson() => _$PomeLabDataToJson(this);
}

@JsonSerializable()
class PomeLabPeriod {
  final String? from;
  final String? to;

  PomeLabPeriod({this.from, this.to});

  factory PomeLabPeriod.fromJson(Map<String, dynamic> json) =>
      _$PomeLabPeriodFromJson(json);
  Map<String, dynamic> toJson() => _$PomeLabPeriodToJson(this);
}

@JsonSerializable()
class PomeLabStatistics {
  @JsonKey(name: "total_truk_masuk")
  final int totalTrukMasuk;

  @JsonKey(name: "truk_belum_cek_lab")
  final int belumCekLab;

  @JsonKey(name: "truk_sudah_cek_lab")
  final int sudahCekLab;

  @JsonKey(name: "total_truk_keluar")
  final int totalTrukKeluar;

  PomeLabStatistics({
    required this.totalTrukMasuk,
    required this.belumCekLab,
    required this.sudahCekLab,
    required this.totalTrukKeluar,
  });

  factory PomeLabStatistics.fromJson(Map<String, dynamic> json) =>
      _$PomeLabStatisticsFromJson(json);
  Map<String, dynamic> toJson() => _$PomeLabStatisticsToJson(this);
}
