// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'manager_check_detail_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ManagerCheckDetailResponse _$ManagerCheckDetailResponseFromJson(
  Map<String, dynamic> json,
) => ManagerCheckDetailResponse(
  success: json['success'] as bool?,
  message: json['message'] as String?,
  data: json['data'] == null
      ? null
      : ManagerCheckDetail.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ManagerCheckDetailResponseToJson(
  ManagerCheckDetailResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data,
};
