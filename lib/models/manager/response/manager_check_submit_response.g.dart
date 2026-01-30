// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'manager_check_submit_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ManagerCheckSubmitResponse _$ManagerCheckSubmitResponseFromJson(
  Map<String, dynamic> json,
) => ManagerCheckSubmitResponse(
  success: json['success'] as bool?,
  message: json['message'] as String?,
  data: json['data'] == null
      ? null
      : ManagerCheck.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ManagerCheckSubmitResponseToJson(
  ManagerCheckSubmitResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data,
};
