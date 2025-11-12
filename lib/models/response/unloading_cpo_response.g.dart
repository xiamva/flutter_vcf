// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unloading_cpo_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UnloadingCPOResponse _$UnloadingCPOResponseFromJson(
  Map<String, dynamic> json,
) => UnloadingCPOResponse(
  success: json['success'] as bool,
  message: json['message'] as String?,
  data: (json['data'] as List<dynamic>?)
      ?.map((e) => UnloadingCpoModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  total: (json['total'] as num?)?.toInt(),
);

Map<String, dynamic> _$UnloadingCPOResponseToJson(
  UnloadingCPOResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data,
  'total': instance.total,
};
