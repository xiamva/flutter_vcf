// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'submit_unloading_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubmitUnloadingResponse _$SubmitUnloadingResponseFromJson(
  Map<String, dynamic> json,
) => SubmitUnloadingResponse(
  success: json['success'] as bool,
  message: json['message'] as String?,
);

Map<String, dynamic> _$SubmitUnloadingResponseToJson(
  SubmitUnloadingResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
};
