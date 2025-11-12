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
  data: json['data'] == null
      ? null
      : SubmitUnloadingData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$SubmitUnloadingResponseToJson(
  SubmitUnloadingResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data,
};

SubmitUnloadingData _$SubmitUnloadingDataFromJson(Map<String, dynamic> json) =>
    SubmitUnloadingData(
      registration_id: json['registration_id'] as String?,
      unloading_status: json['unloading_status'] as String?,
      updated_at: json['updated_at'] as String?,
    );

Map<String, dynamic> _$SubmitUnloadingDataToJson(
  SubmitUnloadingData instance,
) => <String, dynamic>{
  'registration_id': instance.registration_id,
  'unloading_status': instance.unloading_status,
  'updated_at': instance.updated_at,
};
