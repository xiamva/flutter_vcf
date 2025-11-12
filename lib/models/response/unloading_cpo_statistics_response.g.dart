// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unloading_cpo_statistics_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UnloadingCpoStatisticsResponse _$UnloadingCpoStatisticsResponseFromJson(
  Map<String, dynamic> json,
) => UnloadingCpoStatisticsResponse(
  success: json['success'] as bool,
  message: json['message'] as String,
  data: json['data'] == null
      ? null
      : UnloadingStatisticsData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$UnloadingCpoStatisticsResponseToJson(
  UnloadingCpoStatisticsResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data,
};

UnloadingStatisticsData _$UnloadingStatisticsDataFromJson(
  Map<String, dynamic> json,
) => UnloadingStatisticsData(
  period: json['period'] == null
      ? null
      : UnloadingPeriod.fromJson(json['period'] as Map<String, dynamic>),
  statistics: json['statistics'] == null
      ? null
      : UnloadingStatistics.fromJson(
          json['statistics'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$UnloadingStatisticsDataToJson(
  UnloadingStatisticsData instance,
) => <String, dynamic>{
  'period': instance.period,
  'statistics': instance.statistics,
};

UnloadingPeriod _$UnloadingPeriodFromJson(Map<String, dynamic> json) =>
    UnloadingPeriod(from: json['from'] as String?, to: json['to'] as String?);

Map<String, dynamic> _$UnloadingPeriodToJson(UnloadingPeriod instance) =>
    <String, dynamic>{'from': instance.from, 'to': instance.to};

UnloadingStatistics _$UnloadingStatisticsFromJson(Map<String, dynamic> json) =>
    UnloadingStatistics(
      total_truk_masuk: (json['total_truk_masuk'] as num).toInt(),
      truk_belum_unloading: (json['truk_belum_unloading'] as num).toInt(),
      truk_sudah_unloading: (json['truk_sudah_unloading'] as num).toInt(),
      total_truk_keluar: (json['total_truk_keluar'] as num).toInt(),
    );

Map<String, dynamic> _$UnloadingStatisticsToJson(
  UnloadingStatistics instance,
) => <String, dynamic>{
  'total_truk_masuk': instance.total_truk_masuk,
  'truk_belum_unloading': instance.truk_belum_unloading,
  'truk_sudah_unloading': instance.truk_sudah_unloading,
  'total_truk_keluar': instance.total_truk_keluar,
};
