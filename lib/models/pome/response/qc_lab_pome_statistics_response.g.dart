// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'qc_lab_pome_statistics_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QcLabPomeStatisticsResponse _$QcLabPomeStatisticsResponseFromJson(
  Map<String, dynamic> json,
) => QcLabPomeStatisticsResponse(
  success: json['success'] as bool,
  message: json['message'] as String?,
  data: json['data'] == null
      ? null
      : PomeLabData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$QcLabPomeStatisticsResponseToJson(
  QcLabPomeStatisticsResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data,
};

PomeLabData _$PomeLabDataFromJson(Map<String, dynamic> json) => PomeLabData(
  period: json['period'] == null
      ? null
      : PomeLabPeriod.fromJson(json['period'] as Map<String, dynamic>),
  statistics: json['statistics'] == null
      ? null
      : PomeLabStatistics.fromJson(json['statistics'] as Map<String, dynamic>),
);

Map<String, dynamic> _$PomeLabDataToJson(PomeLabData instance) =>
    <String, dynamic>{
      'period': instance.period,
      'statistics': instance.statistics,
    };

PomeLabPeriod _$PomeLabPeriodFromJson(Map<String, dynamic> json) =>
    PomeLabPeriod(from: json['from'] as String?, to: json['to'] as String?);

Map<String, dynamic> _$PomeLabPeriodToJson(PomeLabPeriod instance) =>
    <String, dynamic>{'from': instance.from, 'to': instance.to};

PomeLabStatistics _$PomeLabStatisticsFromJson(Map<String, dynamic> json) =>
    PomeLabStatistics(
      totalTrukMasuk: (json['total_truk_masuk'] as num).toInt(),
      belumCekLab: (json['truk_belum_cek_lab'] as num).toInt(),
      sudahCekLab: (json['truk_sudah_cek_lab'] as num).toInt(),
      totalTrukKeluar: (json['total_truk_keluar'] as num).toInt(),
    );

Map<String, dynamic> _$PomeLabStatisticsToJson(PomeLabStatistics instance) =>
    <String, dynamic>{
      'total_truk_masuk': instance.totalTrukMasuk,
      'truk_belum_cek_lab': instance.belumCekLab,
      'truk_sudah_cek_lab': instance.sudahCekLab,
      'total_truk_keluar': instance.totalTrukKeluar,
    };
