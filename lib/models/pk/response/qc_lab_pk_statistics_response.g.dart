// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'qc_lab_pk_statistics_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QcLabPkStatisticsResponse _$QcLabPkStatisticsResponseFromJson(
  Map<String, dynamic> json,
) => QcLabPkStatisticsResponse(
  success: json['success'] as bool?,
  message: json['message'] as String?,
  data: json['data'] == null
      ? null
      : QcLabPkStatisticsData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$QcLabPkStatisticsResponseToJson(
  QcLabPkStatisticsResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data,
};

QcLabPkStatisticsData _$QcLabPkStatisticsDataFromJson(
  Map<String, dynamic> json,
) => QcLabPkStatisticsData(
  statistics: json['statistics'] == null
      ? null
      : QcLabPkStatistics.fromJson(json['statistics'] as Map<String, dynamic>),
);

Map<String, dynamic> _$QcLabPkStatisticsDataToJson(
  QcLabPkStatisticsData instance,
) => <String, dynamic>{'statistics': instance.statistics};

QcLabPkStatistics _$QcLabPkStatisticsFromJson(Map<String, dynamic> json) =>
    QcLabPkStatistics(
      total_truk_masuk: (json['total_truk_masuk'] as num?)?.toInt(),
      truk_belum_cek_lab: (json['truk_belum_cek_lab'] as num?)?.toInt(),
      truk_sudah_cek_lab: (json['truk_sudah_cek_lab'] as num?)?.toInt(),
      total_truk_keluar: (json['total_truk_keluar'] as num?)?.toInt(),
    );

Map<String, dynamic> _$QcLabPkStatisticsToJson(QcLabPkStatistics instance) =>
    <String, dynamic>{
      'total_truk_masuk': instance.total_truk_masuk,
      'truk_belum_cek_lab': instance.truk_belum_cek_lab,
      'truk_sudah_cek_lab': instance.truk_sudah_cek_lab,
      'total_truk_keluar': instance.total_truk_keluar,
    };
