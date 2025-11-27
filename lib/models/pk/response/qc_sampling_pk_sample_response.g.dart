// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'qc_sampling_pk_sample_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QcSamplingPkSampleResponse _$QcSamplingPkSampleResponseFromJson(
  Map<String, dynamic> json,
) => QcSamplingPkSampleResponse(
  success: json['success'] as bool,
  message: json['message'] as String,
  data: json['data'] == null
      ? null
      : QcSamplingPkSampleData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$QcSamplingPkSampleResponseToJson(
  QcSamplingPkSampleResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data,
};

QcSamplingPkSampleData _$QcSamplingPkSampleDataFromJson(
  Map<String, dynamic> json,
) => QcSamplingPkSampleData(
  registration_id: json['registration_id'] as String,
  process_id: json['process_id'] as String?,
  plate_number: json['plate_number'] as String?,
  wb_ticket_no: json['wb_ticket_no'] as String?,
  driver_name: json['driver_name'] as String,
  vendor_code: json['vendor_code'] as String,
  vendor_name: json['vendor_name'] as String,
  commodity_code: json['commodity_code'] as String,
  commodity_name: json['commodity_name'] as String,
  commodity_type: json['commodity_type'] as String,
  transporter_name: json['transporter_name'] as String,
  regist_status: json['regist_status'] as String,
  has_sampling_data: json['has_sampling_data'] as bool,
  sampling_count: (json['sampling_count'] as num).toInt(),
  sampling_records: (json['sampling_records'] as List<dynamic>)
      .map((e) => QcSamplingPkRecord.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$QcSamplingPkSampleDataToJson(
  QcSamplingPkSampleData instance,
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
  'has_sampling_data': instance.has_sampling_data,
  'sampling_count': instance.sampling_count,
  'sampling_records': instance.sampling_records,
};

QcSamplingPkRecord _$QcSamplingPkRecordFromJson(Map<String, dynamic> json) =>
    QcSamplingPkRecord(
      sampling_id: json['sampling_id'] as String,
      counter: (json['counter'] as num).toInt(),
      kernel_dirt: (json['kernel_dirt'] as num?)?.toDouble(),
      oil_content_estimate: (json['oil_content_estimate'] as num?)?.toDouble(),
      sampled_at: json['sampled_at'] as String?,
      sampled_by: json['sampled_by'] as String?,
      photos_count: (json['photos_count'] as num).toInt(),
      photos: (json['photos'] as List<dynamic>)
          .map((e) => QcSamplingPkPhoto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$QcSamplingPkRecordToJson(QcSamplingPkRecord instance) =>
    <String, dynamic>{
      'sampling_id': instance.sampling_id,
      'counter': instance.counter,
      'kernel_dirt': instance.kernel_dirt,
      'oil_content_estimate': instance.oil_content_estimate,
      'sampled_at': instance.sampled_at,
      'sampled_by': instance.sampled_by,
      'photos_count': instance.photos_count,
      'photos': instance.photos,
    };

QcSamplingPkPhoto _$QcSamplingPkPhotoFromJson(Map<String, dynamic> json) =>
    QcSamplingPkPhoto(
      photo_id: json['photo_id'] as String,
      sequence: (json['sequence'] as num).toInt(),
      path: json['path'] as String,
      url: json['url'] as String,
      taken_at: json['taken_at'] as String?,
    );

Map<String, dynamic> _$QcSamplingPkPhotoToJson(QcSamplingPkPhoto instance) =>
    <String, dynamic>{
      'photo_id': instance.photo_id,
      'sequence': instance.sequence,
      'path': instance.path,
      'url': instance.url,
      'taken_at': instance.taken_at,
    };
