// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unloading_pk_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UnloadingPkResponse _$UnloadingPkResponseFromJson(Map<String, dynamic> json) =>
    UnloadingPkResponse(
      success: json['success'] as bool,
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>)
          .map((e) => UnloadingPkModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num?)?.toInt(),
    );

Map<String, dynamic> _$UnloadingPkResponseToJson(
  UnloadingPkResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data,
  'total': instance.total,
};
