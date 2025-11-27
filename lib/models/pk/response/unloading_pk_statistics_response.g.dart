// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unloading_pk_statistics_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UnloadingPkStatisticsResponse _$UnloadingPkStatisticsResponseFromJson(
  Map<String, dynamic> json,
) => UnloadingPkStatisticsResponse(
  success: json['success'] as bool?,
  message: json['message'] as String?,
  data: json['data'] == null
      ? null
      : UnloadingPkStatisticsData.fromJson(
          json['data'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$UnloadingPkStatisticsResponseToJson(
  UnloadingPkStatisticsResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data,
};

UnloadingPkStatisticsData _$UnloadingPkStatisticsDataFromJson(
  Map<String, dynamic> json,
) => UnloadingPkStatisticsData(
  statistics: json['statistics'] == null
      ? null
      : UnloadingPkStatistics.fromJson(
          json['statistics'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$UnloadingPkStatisticsDataToJson(
  UnloadingPkStatisticsData instance,
) => <String, dynamic>{'statistics': instance.statistics};

UnloadingPkStatistics _$UnloadingPkStatisticsFromJson(
  Map<String, dynamic> json,
) => UnloadingPkStatistics(
  totalTrukMasuk: (json['total_truk_masuk'] as num?)?.toInt(),
  trukBelumUnloading: (json['truk_belum_unloading'] as num?)?.toInt(),
  trukSudahUnloading: (json['truk_sudah_unloading'] as num?)?.toInt(),
  totalTrukKeluar: (json['total_truk_keluar'] as num?)?.toInt(),
);

Map<String, dynamic> _$UnloadingPkStatisticsToJson(
  UnloadingPkStatistics instance,
) => <String, dynamic>{
  'total_truk_masuk': instance.totalTrukMasuk,
  'truk_belum_unloading': instance.trukBelumUnloading,
  'truk_sudah_unloading': instance.trukSudahUnloading,
  'total_truk_keluar': instance.totalTrukKeluar,
};
