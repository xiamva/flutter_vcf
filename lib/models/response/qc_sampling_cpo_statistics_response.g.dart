// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'qc_sampling_cpo_statistics_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QcSamplingCpoStatisticsResponse _$QcSamplingCpoStatisticsResponseFromJson(
  Map<String, dynamic> json,
) => QcSamplingCpoStatisticsResponse(
  success: json['success'] as bool,
  message: json['message'] as String,
  data: json['data'] == null
      ? null
      : QcSamplingStatisticsData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$QcSamplingCpoStatisticsResponseToJson(
  QcSamplingCpoStatisticsResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data,
};

QcSamplingStatisticsData _$QcSamplingStatisticsDataFromJson(
  Map<String, dynamic> json,
) => QcSamplingStatisticsData(
  period: json['period'] == null
      ? null
      : QcSamplingPeriod.fromJson(json['period'] as Map<String, dynamic>),
  statistics: json['statistics'] == null
      ? null
      : QcSamplingStatistics.fromJson(
          json['statistics'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$QcSamplingStatisticsDataToJson(
  QcSamplingStatisticsData instance,
) => <String, dynamic>{
  'period': instance.period,
  'statistics': instance.statistics,
};

QcSamplingPeriod _$QcSamplingPeriodFromJson(Map<String, dynamic> json) =>
    QcSamplingPeriod(from: json['from'] as String?, to: json['to'] as String?);

Map<String, dynamic> _$QcSamplingPeriodToJson(QcSamplingPeriod instance) =>
    <String, dynamic>{'from': instance.from, 'to': instance.to};

QcSamplingStatistics _$QcSamplingStatisticsFromJson(
  Map<String, dynamic> json,
) => QcSamplingStatistics(
  total_truk_masuk: (json['total_truk_masuk'] as num).toInt(),
  truk_belum_ambil_sample: (json['truk_belum_ambil_sample'] as num).toInt(),
  truk_sudah_ambil_sample: (json['truk_sudah_ambil_sample'] as num).toInt(),
  total_truk_keluar: (json['total_truk_keluar'] as num).toInt(),
);

Map<String, dynamic> _$QcSamplingStatisticsToJson(
  QcSamplingStatistics instance,
) => <String, dynamic>{
  'total_truk_masuk': instance.total_truk_masuk,
  'truk_belum_ambil_sample': instance.truk_belum_ambil_sample,
  'truk_sudah_ambil_sample': instance.truk_sudah_ambil_sample,
  'total_truk_keluar': instance.total_truk_keluar,
};
