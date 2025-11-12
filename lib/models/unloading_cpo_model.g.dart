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
    };
