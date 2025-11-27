// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unloading_pk_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UnloadingPkModel _$UnloadingPkModelFromJson(Map<String, dynamic> json) =>
    UnloadingPkModel(
      registrationId: json['registration_id'] as String?,
      processId: json['process_id'] as String?,
      plateNumber: json['plate_number'] as String?,
      wbTicketNo: json['wb_ticket_no'] as String?,
      driverName: json['driver_name'] as String?,
      vendorCode: json['vendor_code'] as String?,
      vendorName: json['vendor_name'] as String?,
      commodityCode: json['commodity_code'] as String?,
      commodityName: json['commodity_name'] as String?,
      commodityType: json['commodity_type'] as String?,
      transporterName: json['transporter_name'] as String?,
      registStatus: json['regist_status'] as String?,
      unloadingId: json['unloading_id'] as String?,
      unloadingStatus: json['unloading_status'] as String?,
      tankId: (json['tank_id'] as num?)?.toInt(),
      tankCode: json['tank_code'] as String?,
      tankName: json['tank_name'] as String?,
      holeId: (json['hole_id'] as num?)?.toInt(),
      holeCode: json['hole_code'] as String?,
      holeName: json['hole_name'] as String?,
      startTime: json['start_time'] as String?,
      endTime: json['end_time'] as String?,
      durationMinutes: (json['duration_minutes'] as num?)?.toInt(),
      operatorId: json['operator_id'] as String?,
      hasUnloadingData: json['has_unloading_data'] as bool?,
      vendorFfa: json['vendor_ffa'] as String?,
      vendorMoisture: json['vendor_moisture'] as String?,
      brutoWeight: json['bruto_weight'] as String?,
    );

Map<String, dynamic> _$UnloadingPkModelToJson(UnloadingPkModel instance) =>
    <String, dynamic>{
      'registration_id': instance.registrationId,
      'process_id': instance.processId,
      'plate_number': instance.plateNumber,
      'wb_ticket_no': instance.wbTicketNo,
      'driver_name': instance.driverName,
      'vendor_code': instance.vendorCode,
      'vendor_name': instance.vendorName,
      'commodity_code': instance.commodityCode,
      'commodity_name': instance.commodityName,
      'commodity_type': instance.commodityType,
      'transporter_name': instance.transporterName,
      'regist_status': instance.registStatus,
      'unloading_id': instance.unloadingId,
      'unloading_status': instance.unloadingStatus,
      'tank_id': instance.tankId,
      'tank_code': instance.tankCode,
      'tank_name': instance.tankName,
      'hole_id': instance.holeId,
      'hole_code': instance.holeCode,
      'hole_name': instance.holeName,
      'start_time': instance.startTime,
      'end_time': instance.endTime,
      'duration_minutes': instance.durationMinutes,
      'operator_id': instance.operatorId,
      'has_unloading_data': instance.hasUnloadingData,
      'vendor_ffa': instance.vendorFfa,
      'vendor_moisture': instance.vendorMoisture,
      'bruto_weight': instance.brutoWeight,
    };
