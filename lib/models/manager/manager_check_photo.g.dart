// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'manager_check_photo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ManagerCheckPhoto _$ManagerCheckPhotoFromJson(Map<String, dynamic> json) =>
    ManagerCheckPhoto(
      photo_id: json['photo_id'] as String?,
      photo_sequence: (json['photo_sequence'] as num?)?.toInt(),
      photo_data: json['photo_data'] as String?,
    );

Map<String, dynamic> _$ManagerCheckPhotoToJson(ManagerCheckPhoto instance) =>
    <String, dynamic>{
      'photo_id': instance.photo_id,
      'photo_sequence': instance.photo_sequence,
      'photo_data': instance.photo_data,
    };
