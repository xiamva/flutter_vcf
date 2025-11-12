import 'package:json_annotation/json_annotation.dart';

part 'qc_sampling_pome_statistics_response.g.dart';

@JsonSerializable()
class QcSamplingPomeStatisticsResponse {
  final bool success;
  final String message;
  final QcSamplingPomeData? data;

  QcSamplingPomeStatisticsResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory QcSamplingPomeStatisticsResponse.fromJson(Map<String, dynamic> json) =>
      _$QcSamplingPomeStatisticsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$QcSamplingPomeStatisticsResponseToJson(this);
}

@JsonSerializable()
class QcSamplingPomeData {
  final QcSamplingPomePeriod? period;
  final QcSamplingPomeStats? statistics;

  QcSamplingPomeData({this.period, this.statistics});

  factory QcSamplingPomeData.fromJson(Map<String, dynamic> json) =>
      _$QcSamplingPomeDataFromJson(json);
}

@JsonSerializable()
class QcSamplingPomePeriod {
  final String? from;
  final String? to;

  QcSamplingPomePeriod({this.from, this.to});

  factory QcSamplingPomePeriod.fromJson(Map<String, dynamic> json) =>
      _$QcSamplingPomePeriodFromJson(json);
}

@JsonSerializable()
class QcSamplingPomeStats {
  @JsonKey(name: "total_truk_masuk")
  final int totalTrukMasuk;

  @JsonKey(name: "truk_belum_ambil_sample")
  final int trukBelumSample;

  @JsonKey(name: "truk_sudah_ambil_sample")
  final int trukSudahSample;

  @JsonKey(name: "total_truk_keluar")
  final int totalTrukKeluar;

  QcSamplingPomeStats({
    required this.totalTrukMasuk,
    required this.trukBelumSample,
    required this.trukSudahSample,
    required this.totalTrukKeluar,
  });

  factory QcSamplingPomeStats.fromJson(Map<String, dynamic> json) =>
      _$QcSamplingPomeStatsFromJson(json);
}
