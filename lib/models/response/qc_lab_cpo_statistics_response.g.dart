// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'qc_lab_cpo_statistics_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QcLabCpoStatisticsResponse _$QcLabCpoStatisticsResponseFromJson(
  Map<String, dynamic> json,
) => QcLabCpoStatisticsResponse(
  success: json['success'] as bool,
  message: json['message'] as String,
  data: json['data'] == null
      ? null
      : QcLabCpoStatisticsData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$QcLabCpoStatisticsResponseToJson(
  QcLabCpoStatisticsResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data,
};

QcLabCpoStatisticsData _$QcLabCpoStatisticsDataFromJson(
  Map<String, dynamic> json,
) => QcLabCpoStatisticsData(
  period: json['period'] == null
      ? null
      : QcLabCpoPeriod.fromJson(json['period'] as Map<String, dynamic>),
  statistics: json['statistics'] == null
      ? null
      : QcLabCpoStats.fromJson(json['statistics'] as Map<String, dynamic>),
);

Map<String, dynamic> _$QcLabCpoStatisticsDataToJson(
  QcLabCpoStatisticsData instance,
) => <String, dynamic>{
  'period': instance.period,
  'statistics': instance.statistics,
};

QcLabCpoPeriod _$QcLabCpoPeriodFromJson(Map<String, dynamic> json) =>
    QcLabCpoPeriod(from: json['from'] as String?, to: json['to'] as String?);

Map<String, dynamic> _$QcLabCpoPeriodToJson(QcLabCpoPeriod instance) =>
    <String, dynamic>{'from': instance.from, 'to': instance.to};

QcLabCpoStats _$QcLabCpoStatsFromJson(Map<String, dynamic> json) =>
    QcLabCpoStats(
      total_truk_masuk: (json['total_truk_masuk'] as num).toInt(),
      truk_belum_cek_lab: (json['truk_belum_cek_lab'] as num).toInt(),
      truk_sudah_cek_lab: (json['truk_sudah_cek_lab'] as num).toInt(),
      total_truk_keluar: (json['total_truk_keluar'] as num).toInt(),
    );

Map<String, dynamic> _$QcLabCpoStatsToJson(QcLabCpoStats instance) =>
    <String, dynamic>{
      'total_truk_masuk': instance.total_truk_masuk,
      'truk_belum_cek_lab': instance.truk_belum_cek_lab,
      'truk_sudah_cek_lab': instance.truk_sudah_cek_lab,
      'total_truk_keluar': instance.total_truk_keluar,
    };
