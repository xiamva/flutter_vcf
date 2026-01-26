// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'manager_check_statistics_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ManagerCheckStatisticsResponse _$ManagerCheckStatisticsResponseFromJson(
  Map<String, dynamic> json,
) => ManagerCheckStatisticsResponse(
  success: json['success'] as bool?,
  message: json['message'] as String?,
  data: json['data'] == null
      ? null
      : ManagerCheckStatistics.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ManagerCheckStatisticsResponseToJson(
  ManagerCheckStatisticsResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data,
};
