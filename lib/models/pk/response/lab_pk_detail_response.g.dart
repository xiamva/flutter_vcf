// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lab_pk_detail_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LabPkDetailResponse _$LabPkDetailResponseFromJson(Map<String, dynamic> json) =>
    LabPkDetailResponse(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      data: json['data'] == null
          ? null
          : LabPkDetailData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LabPkDetailResponseToJson(
  LabPkDetailResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data,
};

LabPkDetailData _$LabPkDetailDataFromJson(Map<String, dynamic> json) =>
    LabPkDetailData(
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
      hasLabData: json['has_lab_data'] as bool?,
      labRecords: (json['lab_records'] as List<dynamic>?)
          ?.map((e) => LabPkRecord.fromJson(e as Map<String, dynamic>))
          .toList(),
      labCount: (json['lab_count'] as num?)?.toInt(),
      vendorFfa: json['vendor_ffa'] as String?,
      vendorMoisture: json['vendor_moisture'] as String?,
    );

Map<String, dynamic> _$LabPkDetailDataToJson(LabPkDetailData instance) =>
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
      'has_lab_data': instance.hasLabData,
      'lab_records': instance.labRecords,
      'lab_count': instance.labCount,
      'vendor_ffa': instance.vendorFfa,
      'vendor_moisture': instance.vendorMoisture,
    };

LabPkRecord _$LabPkRecordFromJson(Map<String, dynamic> json) => LabPkRecord(
  labId: json['lab_id'] as String?,
  counter: (json['counter'] as num?)?.toInt(),
  ffa: json['ffa'] as String?,
  moisture: json['moisture'] as String?,
  dirt: json['dirt'] as String?,
  oilContent: json['oil_content'] as String?,
  remarks: json['remarks'] as String?,
  status: json['status'] as String?,
  testedAt: json['tested_at'] as String?,
  testedBy: json['tested_by'] as String?,
  photos: (json['photos'] as List<dynamic>?)
      ?.map((e) => LabPkPhoto.fromJson(e as Map<String, dynamic>))
      .toList(),
  photosCount: (json['photos_count'] as num?)?.toInt(),
);

Map<String, dynamic> _$LabPkRecordToJson(LabPkRecord instance) =>
    <String, dynamic>{
      'lab_id': instance.labId,
      'counter': instance.counter,
      'ffa': instance.ffa,
      'moisture': instance.moisture,
      'dirt': instance.dirt,
      'oil_content': instance.oilContent,
      'remarks': instance.remarks,
      'status': instance.status,
      'tested_at': instance.testedAt,
      'tested_by': instance.testedBy,
      'photos': instance.photos,
      'photos_count': instance.photosCount,
    };

LabPkPhoto _$LabPkPhotoFromJson(Map<String, dynamic> json) => LabPkPhoto(
  photoId: json['photo_id'] as String?,
  sequence: (json['sequence'] as num?)?.toInt(),
  path: json['path'] as String?,
  url: json['url'] as String?,
  takenAt: json['taken_at'] as String?,
);

Map<String, dynamic> _$LabPkPhotoToJson(LabPkPhoto instance) =>
    <String, dynamic>{
      'photo_id': instance.photoId,
      'sequence': instance.sequence,
      'path': instance.path,
      'url': instance.url,
      'taken_at': instance.takenAt,
    };
