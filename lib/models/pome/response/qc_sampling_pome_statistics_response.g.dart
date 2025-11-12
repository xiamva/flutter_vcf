// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'qc_sampling_pome_statistics_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QcSamplingPomeStatisticsResponse _$QcSamplingPomeStatisticsResponseFromJson(
  Map<String, dynamic> json,
) => QcSamplingPomeStatisticsResponse(
  success: json['success'] as bool,
  message: json['message'] as String,
  data: json['data'] == null
      ? null
      : QcSamplingPomeData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$QcSamplingPomeStatisticsResponseToJson(
  QcSamplingPomeStatisticsResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data,
};

QcSamplingPomeData _$QcSamplingPomeDataFromJson(Map<String, dynamic> json) =>
    QcSamplingPomeData(
      period: json['period'] == null
          ? null
          : QcSamplingPomePeriod.fromJson(
              json['period'] as Map<String, dynamic>,
            ),
      statistics: json['statistics'] == null
          ? null
          : QcSamplingPomeStats.fromJson(
              json['statistics'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$QcSamplingPomeDataToJson(QcSamplingPomeData instance) =>
    <String, dynamic>{
      'period': instance.period,
      'statistics': instance.statistics,
    };

QcSamplingPomePeriod _$QcSamplingPomePeriodFromJson(
  Map<String, dynamic> json,
) => QcSamplingPomePeriod(
  from: json['from'] as String?,
  to: json['to'] as String?,
);

Map<String, dynamic> _$QcSamplingPomePeriodToJson(
  QcSamplingPomePeriod instance,
) => <String, dynamic>{'from': instance.from, 'to': instance.to};

QcSamplingPomeStats _$QcSamplingPomeStatsFromJson(Map<String, dynamic> json) =>
    QcSamplingPomeStats(
      totalTrukMasuk: (json['total_truk_masuk'] as num).toInt(),
      trukBelumSample: (json['truk_belum_ambil_sample'] as num).toInt(),
      trukSudahSample: (json['truk_sudah_ambil_sample'] as num).toInt(),
      totalTrukKeluar: (json['total_truk_keluar'] as num).toInt(),
    );

Map<String, dynamic> _$QcSamplingPomeStatsToJson(
  QcSamplingPomeStats instance,
) => <String, dynamic>{
  'total_truk_masuk': instance.totalTrukMasuk,
  'truk_belum_ambil_sample': instance.trukBelumSample,
  'truk_sudah_ambil_sample': instance.trukSudahSample,
  'total_truk_keluar': instance.totalTrukKeluar,
};
