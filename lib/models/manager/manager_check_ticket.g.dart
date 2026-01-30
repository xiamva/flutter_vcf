// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'manager_check_ticket.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PreviousCheck _$PreviousCheckFromJson(Map<String, dynamic> json) =>
    PreviousCheck(
      stage: json['stage'] as String?,
      check_status: json['check_status'] as String?,
      checked_by: json['checked_by'] as String?,
      checked_at: json['checked_at'] as String?,
    );

Map<String, dynamic> _$PreviousCheckToJson(PreviousCheck instance) =>
    <String, dynamic>{
      'stage': instance.stage,
      'check_status': instance.check_status,
      'checked_by': instance.checked_by,
      'checked_at': instance.checked_at,
    };

ManagerCheckTicket _$ManagerCheckTicketFromJson(Map<String, dynamic> json) =>
    ManagerCheckTicket(
      process_id: json['process_id'] as String?,
      registration_id: json['registration_id'] as String?,
      wb_ticket_no: json['wb_ticket_no'] as String?,
      plate_number: json['plate_number'] as String?,
      driver_name: json['driver_name'] as String?,
      vendor_name: json['vendor_name'] as String?,
      commodity_type: json['commodity_type'] as String?,
      current_stage: json['current_stage'] as String?,
      created_at: json['created_at'] as String?,
      has_manager_check: json['has_manager_check'] as bool?,
      manager_checks_count: (json['manager_checks_count'] as num?)?.toInt(),
      latest_check_status: json['latest_check_status'] as String?,
      previous_checks: (json['previous_checks'] as List<dynamic>?)
          ?.map((e) => PreviousCheck.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ManagerCheckTicketToJson(ManagerCheckTicket instance) =>
    <String, dynamic>{
      'process_id': instance.process_id,
      'registration_id': instance.registration_id,
      'wb_ticket_no': instance.wb_ticket_no,
      'plate_number': instance.plate_number,
      'driver_name': instance.driver_name,
      'vendor_name': instance.vendor_name,
      'commodity_type': instance.commodity_type,
      'current_stage': instance.current_stage,
      'created_at': instance.created_at,
      'has_manager_check': instance.has_manager_check,
      'manager_checks_count': instance.manager_checks_count,
      'latest_check_status': instance.latest_check_status,
      'previous_checks': instance.previous_checks,
    };
