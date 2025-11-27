// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unloading_cpo_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UnloadingCpoModel _$UnloadingCpoModelFromJson(Map<String, dynamic> json) =>
    UnloadingCpoModel(
      registration_id: json['registration_id'] as String?,
      wb_ticket_no: json['wb_ticket_no'] as String?,
      plate_number: json['plate_number'] as String?,
      driver_name: json['driver_name'] as String?,
      vendor_code: json['vendor_code'] as String?,
      vendor_name: json['vendor_name'] as String?,
      commodity_code: json['commodity_code'] as String?,
      commodity_name: json['commodity_name'] as String?,
      transporter_name: json['transporter_name'] as String?,
      regist_status: json['regist_status'] as String?,
      unloading_status: json['unloading_status'] as String?,
      bruto_weight: json['bruto_weight'] as String?,
      vendor_ffa: json['vendor_ffa'] as String?,
      vendor_moisture: json['vendor_moisture'] as String?,
      created_at: json['created_at'] as String?,
      unloading_id: json['unloading_id'] as String?,
      tank_id: (json['tank_id'] as num?)?.toInt(),
      tank_code: json['tank_code'] as String?,
      tank_name: json['tank_name'] as String?,
      hole_id: (json['hole_id'] as num?)?.toInt(),
      hole_code: json['hole_code'] as String?,
      hole_name: json['hole_name'] as String?,
      start_time: json['start_time'] as String?,
      end_time: json['end_time'] as String?,
      duration_minutes: (json['duration_minutes'] as num?)?.toInt(),
      has_unloading_data: json['has_unloading_data'] as bool?,
      photos: (json['photos'] as List<dynamic>?)
          ?.map((e) => UnloadingCpoPhoto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$UnloadingCpoModelToJson(UnloadingCpoModel instance) =>
    <String, dynamic>{
      'registration_id': instance.registration_id,
      'wb_ticket_no': instance.wb_ticket_no,
      'plate_number': instance.plate_number,
      'driver_name': instance.driver_name,
      'vendor_code': instance.vendor_code,
      'vendor_name': instance.vendor_name,
      'commodity_code': instance.commodity_code,
      'commodity_name': instance.commodity_name,
      'transporter_name': instance.transporter_name,
      'regist_status': instance.regist_status,
      'unloading_status': instance.unloading_status,
      'bruto_weight': instance.bruto_weight,
      'vendor_ffa': instance.vendor_ffa,
      'vendor_moisture': instance.vendor_moisture,
      'created_at': instance.created_at,
      'unloading_id': instance.unloading_id,
      'tank_id': instance.tank_id,
      'tank_code': instance.tank_code,
      'tank_name': instance.tank_name,
      'hole_id': instance.hole_id,
      'hole_code': instance.hole_code,
      'hole_name': instance.hole_name,
      'start_time': instance.start_time,
      'end_time': instance.end_time,
      'duration_minutes': instance.duration_minutes,
      'has_unloading_data': instance.has_unloading_data,
      'photos': instance.photos,
    };

UnloadingCpoPhoto _$UnloadingCpoPhotoFromJson(Map<String, dynamic> json) =>
    UnloadingCpoPhoto(
      photo_id: json['photo_id'] as String?,
      sequence: (json['sequence'] as num?)?.toInt(),
      path: json['path'] as String?,
      url: json['url'] as String?,
      taken_at: json['taken_at'] as String?,
    );

Map<String, dynamic> _$UnloadingCpoPhotoToJson(UnloadingCpoPhoto instance) =>
    <String, dynamic>{
      'photo_id': instance.photo_id,
      'sequence': instance.sequence,
      'path': instance.path,
      'url': instance.url,
      'taken_at': instance.taken_at,
    };
