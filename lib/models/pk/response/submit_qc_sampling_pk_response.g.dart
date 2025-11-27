// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'submit_qc_sampling_pk_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubmitQcSamplingPkResponse _$SubmitQcSamplingPkResponseFromJson(
  Map<String, dynamic> json,
) => SubmitQcSamplingPkResponse(
  success: json['success'] as bool,
  message: json['message'] as String,
  data: json['data'] == null
      ? null
      : SubmitQcSamplingPkData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$SubmitQcSamplingPkResponseToJson(
  SubmitQcSamplingPkResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data,
};

SubmitQcSamplingPkData _$SubmitQcSamplingPkDataFromJson(
  Map<String, dynamic> json,
) => SubmitQcSamplingPkData(
  sampling_id: json['sampling_id'] as String,
  process_id: json['process_id'] as String,
  registration_id: json['registration_id'] as String,
  plate_number: json['plate_number'] as String,
  wb_ticket_no: json['wb_ticket_no'] as String,
  vendor_code: json['vendor_code'] as String,
  vendor_name: json['vendor_name'] as String,
  kernel_dirt: json['kernel_dirt'] as num?,
  oil_content_estimate: json['oil_content_estimate'] as num?,
  counter: (json['counter'] as num).toInt(),
  is_resampling: json['is_resampling'] as bool,
  sampled_at: json['sampled_at'] as String,
  sampled_by: json['sampled_by'] as String,
  photos: (json['photos'] as List<dynamic>?)
      ?.map((e) => SubmitQcSamplingPkPhoto.fromJson(e as Map<String, dynamic>))
      .toList(),
  photos_count: (json['photos_count'] as num).toInt(),
);

Map<String, dynamic> _$SubmitQcSamplingPkDataToJson(
  SubmitQcSamplingPkData instance,
) => <String, dynamic>{
  'sampling_id': instance.sampling_id,
  'process_id': instance.process_id,
  'registration_id': instance.registration_id,
  'plate_number': instance.plate_number,
  'wb_ticket_no': instance.wb_ticket_no,
  'vendor_code': instance.vendor_code,
  'vendor_name': instance.vendor_name,
  'kernel_dirt': instance.kernel_dirt,
  'oil_content_estimate': instance.oil_content_estimate,
  'counter': instance.counter,
  'is_resampling': instance.is_resampling,
  'sampled_at': instance.sampled_at,
  'sampled_by': instance.sampled_by,
  'photos': instance.photos,
  'photos_count': instance.photos_count,
};

SubmitQcSamplingPkPhoto _$SubmitQcSamplingPkPhotoFromJson(
  Map<String, dynamic> json,
) => SubmitQcSamplingPkPhoto(
  photo_id: json['photo_id'] as String,
  sequence: (json['sequence'] as num).toInt(),
  path: json['path'] as String,
  url: json['url'] as String,
);

Map<String, dynamic> _$SubmitQcSamplingPkPhotoToJson(
  SubmitQcSamplingPkPhoto instance,
) => <String, dynamic>{
  'photo_id': instance.photo_id,
  'sequence': instance.sequence,
  'path': instance.path,
  'url': instance.url,
};
