// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unloading_pome_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UnloadingPOMEResponse _$UnloadingPOMEResponseFromJson(
  Map<String, dynamic> json,
) => UnloadingPOMEResponse(
  success: json['success'] as bool?,
  message: json['message'] as String?,
  data: (json['data'] as List<dynamic>?)
      ?.map((e) => UnloadingPomeModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$UnloadingPOMEResponseToJson(
  UnloadingPOMEResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data,
};
