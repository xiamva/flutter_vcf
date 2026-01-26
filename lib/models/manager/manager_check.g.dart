// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'manager_check.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ManagerCheck _$ManagerCheckFromJson(Map<String, dynamic> json) => ManagerCheck(
  check_id: json['check_id'] as String?,
  process_id: json['process_id'] as String?,
  ticket_id: json['ticket_id'] as String?,
  commodity: json['commodity'] as String?,
  stage: json['stage'] as String?,
  check_status: json['check_status'] as String?,
  remarks: json['remarks'] as String?,
  mgr_ffa: ManagerCheck._toDouble(json['mgr_ffa']),
  mgr_moisture: ManagerCheck._toDouble(json['mgr_moisture']),
  mgr_dobi: ManagerCheck._toDouble(json['mgr_dobi']),
  mgr_iv: ManagerCheck._toDouble(json['mgr_iv']),
  mgr_dirt: ManagerCheck._toDouble(json['mgr_dirt']),
  mgr_oil_content: ManagerCheck._toDouble(json['mgr_oil_content']),
  mgr_tank_id: (json['mgr_tank_id'] as num?)?.toInt(),
  mgr_hole_id: (json['mgr_hole_id'] as num?)?.toInt(),
  checked_at: json['checked_at'] as String?,
  checked_by: json['checked_by'] as String?,
  photos: (json['photos'] as List<dynamic>?)
      ?.map((e) => ManagerCheckPhoto.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ManagerCheckToJson(ManagerCheck instance) =>
    <String, dynamic>{
      'check_id': instance.check_id,
      'process_id': instance.process_id,
      'ticket_id': instance.ticket_id,
      'commodity': instance.commodity,
      'stage': instance.stage,
      'check_status': instance.check_status,
      'remarks': instance.remarks,
      'mgr_ffa': instance.mgr_ffa,
      'mgr_moisture': instance.mgr_moisture,
      'mgr_dobi': instance.mgr_dobi,
      'mgr_iv': instance.mgr_iv,
      'mgr_dirt': instance.mgr_dirt,
      'mgr_oil_content': instance.mgr_oil_content,
      'mgr_tank_id': instance.mgr_tank_id,
      'mgr_hole_id': instance.mgr_hole_id,
      'checked_at': instance.checked_at,
      'checked_by': instance.checked_by,
      'photos': instance.photos,
    };
