import 'package:json_annotation/json_annotation.dart';

part 'unloading_pk_statistics_response.g.dart';

@JsonSerializable()
class UnloadingPkStatisticsResponse {
  final bool? success;
  final String? message;
  final UnloadingPkStatisticsData? data;

  UnloadingPkStatisticsResponse({
    this.success,
    this.message,
    this.data,
  });

  factory UnloadingPkStatisticsResponse.fromJson(Map<String, dynamic> json)
      => _$UnloadingPkStatisticsResponseFromJson(json);

  Map<String, dynamic> toJson() =>
      _$UnloadingPkStatisticsResponseToJson(this);
}

@JsonSerializable()
class UnloadingPkStatisticsData {
  final UnloadingPkStatistics? statistics;

  UnloadingPkStatisticsData({
    this.statistics,
  });

  factory UnloadingPkStatisticsData.fromJson(Map<String, dynamic> json)
      => _$UnloadingPkStatisticsDataFromJson(json);

  Map<String, dynamic> toJson() =>
      _$UnloadingPkStatisticsDataToJson(this);
}

@JsonSerializable()
class UnloadingPkStatistics {
  @JsonKey(name: "total_truk_masuk")
  final int? totalTrukMasuk;

  @JsonKey(name: "truk_belum_unloading")
  final int? trukBelumUnloading;

  @JsonKey(name: "truk_sudah_unloading")
  final int? trukSudahUnloading;

  @JsonKey(name: "total_truk_keluar")
  final int? totalTrukKeluar;

  UnloadingPkStatistics({
    this.totalTrukMasuk,
    this.trukBelumUnloading,
    this.trukSudahUnloading,
    this.totalTrukKeluar,
  });

  factory UnloadingPkStatistics.fromJson(Map<String, dynamic> json)
      => _$UnloadingPkStatisticsFromJson(json);

  Map<String, dynamic> toJson() =>
      _$UnloadingPkStatisticsToJson(this);
}
