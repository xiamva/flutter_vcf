// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unloading_cpo_detail_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UnloadingCpoDetailResponse _$UnloadingCpoDetailResponseFromJson(
  Map<String, dynamic> json,
) => UnloadingCpoDetailResponse(
  success: json['success'] as bool,
  message: json['message'] as String,
  data: json['data'] == null
      ? null
      : UnloadingCpoDetail.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$UnloadingCpoDetailResponseToJson(
  UnloadingCpoDetailResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data,
};

UnloadingCpoDetail _$UnloadingCpoDetailFromJson(Map<String, dynamic> json) =>
    UnloadingCpoDetail(
      tankId: (json['tank_id'] as num?)?.toInt(),
      holeId: (json['hole_id'] as num?)?.toInt(),
      remarks: json['remarks'] as String?,
      photos: (json['photos'] as List<dynamic>?)
          ?.map((e) => UnloadingPhoto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$UnloadingCpoDetailToJson(UnloadingCpoDetail instance) =>
    <String, dynamic>{
      'tank_id': instance.tankId,
      'hole_id': instance.holeId,
      'remarks': instance.remarks,
      'photos': instance.photos,
    };

UnloadingPhoto _$UnloadingPhotoFromJson(Map<String, dynamic> json) =>
    UnloadingPhoto(url: json['url'] as String?, path: json['path'] as String?);

Map<String, dynamic> _$UnloadingPhotoToJson(UnloadingPhoto instance) =>
    <String, dynamic>{'url': instance.url, 'path': instance.path};
