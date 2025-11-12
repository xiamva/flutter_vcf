// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'submit_qc_sampling_pome_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubmitQcSamplingPomeResponse _$SubmitQcSamplingPomeResponseFromJson(
  Map<String, dynamic> json,
) => SubmitQcSamplingPomeResponse(
  success: json['success'] as bool,
  message: json['message'] as String?,
  data: json['data'] == null
      ? null
      : PomeSamplingData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$SubmitQcSamplingPomeResponseToJson(
  SubmitQcSamplingPomeResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data?.toJson(),
};

PomeSamplingData _$PomeSamplingDataFromJson(Map<String, dynamic> json) =>
    PomeSamplingData(
      sampling_id: json['sampling_id'] as String?,
      process_id: json['process_id'] as String?,
      registration_id: json['registration_id'] as String?,
      plate_number: json['plate_number'] as String?,
      wb_ticket_no: json['wb_ticket_no'] as String?,
      vendor_code: json['vendor_code'] as String?,
      vendor_name: json['vendor_name'] as String?,
      sediment_level: (json['sediment_level'] as num?)?.toDouble(),
      ph_value: (json['ph_value'] as num?)?.toDouble(),
      sampled_at: json['sampled_at'] as String?,
      sampled_by: json['sampled_by'] as String?,
      photos: (json['photos'] as List<dynamic>?)
          ?.map((e) => PomePhoto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PomeSamplingDataToJson(PomeSamplingData instance) =>
    <String, dynamic>{
      'sampling_id': instance.sampling_id,
      'process_id': instance.process_id,
      'registration_id': instance.registration_id,
      'plate_number': instance.plate_number,
      'wb_ticket_no': instance.wb_ticket_no,
      'vendor_code': instance.vendor_code,
      'vendor_name': instance.vendor_name,
      'sediment_level': instance.sediment_level,
      'ph_value': instance.ph_value,
      'sampled_at': instance.sampled_at,
      'sampled_by': instance.sampled_by,
      'photos': instance.photos,
    };

PomePhoto _$PomePhotoFromJson(Map<String, dynamic> json) => PomePhoto(
  photo_id: json['photo_id'] as String?,
  sequence: (json['sequence'] as num?)?.toInt(),
  path: json['path'] as String?,
  url: json['url'] as String?,
);

Map<String, dynamic> _$PomePhotoToJson(PomePhoto instance) => <String, dynamic>{
  'photo_id': instance.photo_id,
  'sequence': instance.sequence,
  'path': instance.path,
  'url': instance.url,
};
