// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unloading_pome_detail_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UnloadingPomeDetailResponse _$UnloadingPomeDetailResponseFromJson(
  Map<String, dynamic> json,
) => UnloadingPomeDetailResponse(
  success: json['success'] as bool,
  message: json['message'] as String,
  data: json['data'] == null
      ? null
      : UnloadingPomeDetail.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$UnloadingPomeDetailResponseToJson(
  UnloadingPomeDetailResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data,
};

UnloadingPomeDetail _$UnloadingPomeDetailFromJson(Map<String, dynamic> json) =>
    UnloadingPomeDetail(
      registration_id: json['registration_id'] as String?,
      process_id: json['process_id'] as String?,
      plate_number: json['plate_number'] as String?,
      wb_ticket_no: json['wb_ticket_no'] as String?,
      driver_name: json['driver_name'] as String?,
      vendor_code: json['vendor_code'] as String?,
      vendor_name: json['vendor_name'] as String?,
      commodity_code: json['commodity_code'] as String?,
      commodity_name: json['commodity_name'] as String?,
      commodity_type: json['commodity_type'] as String?,
      transporter_name: json['transporter_name'] as String?,
      regist_status: json['regist_status'] as String?,
      unloadingId: json['unloading_id'] as String?,
      tankId: UnloadingPomeDetail._toInt(json['tank_id']),
      tank_code: json['tank_code'] as String?,
      tank_name: json['tank_name'] as String?,
      holeId: UnloadingPomeDetail._toInt(json['hole_id']),
      hole_code: json['hole_code'] as String?,
      hole_name: json['hole_name'] as String?,
      unloadingStatus: json['unloading_status'] as String?,
      remarks: json['remarks'] as String?,
      start_time: json['start_time'] as String?,
      end_time: json['end_time'] as String?,
      operatorId: UnloadingPomeDetail._toInt(json['operator_id']),
      has_unloading_data: json['has_unloading_data'] as bool?,
      durationMinutes: UnloadingPomeDetail._toDouble(json['duration_minutes']),
      vendorFfa: UnloadingPomeDetail._toDouble(json['vendor_ffa']),
      vendorMoisture: UnloadingPomeDetail._toDouble(json['vendor_moisture']),
      brutoWeight: UnloadingPomeDetail._toDouble(json['bruto_weight']),
      photos: (json['photos'] as List<dynamic>?)
          ?.map((e) => PomeUnloadingPhoto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$UnloadingPomeDetailToJson(
  UnloadingPomeDetail instance,
) => <String, dynamic>{
  'registration_id': instance.registration_id,
  'process_id': instance.process_id,
  'plate_number': instance.plate_number,
  'wb_ticket_no': instance.wb_ticket_no,
  'driver_name': instance.driver_name,
  'vendor_code': instance.vendor_code,
  'vendor_name': instance.vendor_name,
  'commodity_code': instance.commodity_code,
  'commodity_name': instance.commodity_name,
  'commodity_type': instance.commodity_type,
  'transporter_name': instance.transporter_name,
  'regist_status': instance.regist_status,
  'unloading_id': instance.unloadingId,
  'tank_id': instance.tankId,
  'tank_code': instance.tank_code,
  'tank_name': instance.tank_name,
  'hole_id': instance.holeId,
  'hole_code': instance.hole_code,
  'hole_name': instance.hole_name,
  'unloading_status': instance.unloadingStatus,
  'remarks': instance.remarks,
  'start_time': instance.start_time,
  'end_time': instance.end_time,
  'operator_id': instance.operatorId,
  'has_unloading_data': instance.has_unloading_data,
  'duration_minutes': instance.durationMinutes,
  'vendor_ffa': instance.vendorFfa,
  'vendor_moisture': instance.vendorMoisture,
  'bruto_weight': instance.brutoWeight,
  'photos': instance.photos,
};

PomeUnloadingPhoto _$PomeUnloadingPhotoFromJson(Map<String, dynamic> json) =>
    PomeUnloadingPhoto(
      url: json['url'] as String?,
      path: json['path'] as String?,
    );

Map<String, dynamic> _$PomeUnloadingPhotoToJson(PomeUnloadingPhoto instance) =>
    <String, dynamic>{'url': instance.url, 'path': instance.path};
