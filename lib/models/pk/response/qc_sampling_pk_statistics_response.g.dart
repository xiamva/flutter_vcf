// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'qc_sampling_pk_statistics_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QcSamplingPkStatisticsResponse _$QcSamplingPkStatisticsResponseFromJson(
  Map<String, dynamic> json,
) => QcSamplingPkStatisticsResponse(
  success: json['success'] as bool,
  message: json['message'] as String,
  data: json['data'] == null
      ? null
      : QcSamplingPkStatisticsData.fromJson(
          json['data'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$QcSamplingPkStatisticsResponseToJson(
  QcSamplingPkStatisticsResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data,
};

QcSamplingPkStatisticsData _$QcSamplingPkStatisticsDataFromJson(
  Map<String, dynamic> json,
) => QcSamplingPkStatisticsData(
  period: json['period'] == null
      ? null
      : QcSamplingPkPeriod.fromJson(json['period'] as Map<String, dynamic>),
  statistics: json['statistics'] == null
      ? null
      : QcSamplingPkStatistics.fromJson(
          json['statistics'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$QcSamplingPkStatisticsDataToJson(
  QcSamplingPkStatisticsData instance,
) => <String, dynamic>{
  'period': instance.period,
  'statistics': instance.statistics,
};

QcSamplingPkPeriod _$QcSamplingPkPeriodFromJson(Map<String, dynamic> json) =>
    QcSamplingPkPeriod(
      from: json['from'] as String?,
      to: json['to'] as String?,
    );

Map<String, dynamic> _$QcSamplingPkPeriodToJson(QcSamplingPkPeriod instance) =>
    <String, dynamic>{'from': instance.from, 'to': instance.to};

QcSamplingPkStatistics _$QcSamplingPkStatisticsFromJson(
  Map<String, dynamic> json,
) => QcSamplingPkStatistics(
  total_truk_masuk: (json['total_truk_masuk'] as num).toInt(),
  truk_belum_ambil_sample: (json['truk_belum_ambil_sample'] as num).toInt(),
  truk_sudah_ambil_sample: (json['truk_sudah_ambil_sample'] as num).toInt(),
  total_truk_keluar: (json['total_truk_keluar'] as num).toInt(),
);

Map<String, dynamic> _$QcSamplingPkStatisticsToJson(
  QcSamplingPkStatistics instance,
) => <String, dynamic>{
  'total_truk_masuk': instance.total_truk_masuk,
  'truk_belum_ambil_sample': instance.truk_belum_ambil_sample,
  'truk_sudah_ambil_sample': instance.truk_sudah_ambil_sample,
  'total_truk_keluar': instance.total_truk_keluar,
};
