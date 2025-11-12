// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unloading_pome_statistics_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UnloadingPomeStatisticsResponse _$UnloadingPomeStatisticsResponseFromJson(
  Map<String, dynamic> json,
) => UnloadingPomeStatisticsResponse(
  success: json['success'] as bool?,
  message: json['message'] as String?,
  data: json['data'] == null
      ? null
      : UnloadingPomeStatisticsData.fromJson(
          json['data'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$UnloadingPomeStatisticsResponseToJson(
  UnloadingPomeStatisticsResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data,
};

UnloadingPomeStatisticsData _$UnloadingPomeStatisticsDataFromJson(
  Map<String, dynamic> json,
) => UnloadingPomeStatisticsData(
  statistics: json['statistics'] == null
      ? null
      : UnloadingPomeStatistics.fromJson(
          json['statistics'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$UnloadingPomeStatisticsDataToJson(
  UnloadingPomeStatisticsData instance,
) => <String, dynamic>{'statistics': instance.statistics};

UnloadingPomeStatistics _$UnloadingPomeStatisticsFromJson(
  Map<String, dynamic> json,
) => UnloadingPomeStatistics(
  total_truk_masuk: (json['total_truk_masuk'] as num?)?.toInt() ?? 0,
  truk_belum_unloading: (json['truk_belum_unloading'] as num?)?.toInt() ?? 0,
  truk_sudah_unloading: (json['truk_sudah_unloading'] as num?)?.toInt() ?? 0,
  total_truk_keluar: (json['total_truk_keluar'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$UnloadingPomeStatisticsToJson(
  UnloadingPomeStatistics instance,
) => <String, dynamic>{
  'total_truk_masuk': instance.total_truk_masuk,
  'truk_belum_unloading': instance.truk_belum_unloading,
  'truk_sudah_unloading': instance.truk_sudah_unloading,
  'total_truk_keluar': instance.total_truk_keluar,
};
