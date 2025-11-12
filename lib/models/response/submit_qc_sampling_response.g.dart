// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'submit_qc_sampling_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubmitQcSamplingResponse _$SubmitQcSamplingResponseFromJson(
  Map<String, dynamic> json,
) => SubmitQcSamplingResponse(
  success: json['success'] as bool,
  message: json['message'] as String?,
  data: json['data'] == null
      ? null
      : CpoSamplingData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$SubmitQcSamplingResponseToJson(
  SubmitQcSamplingResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data,
};

CpoSamplingData _$CpoSamplingDataFromJson(Map<String, dynamic> json) =>
    CpoSamplingData(
      samplingId: json['sampling_id'] as String?,
      registrationId: json['registration_id'] as String?,
      oilTemp: json['oil_temp'] as String?,
      visualColor: json['visual_color'] as String?,
      photos: (json['photos'] as List<dynamic>?)
          ?.map((e) => CpoSamplingPhoto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CpoSamplingDataToJson(CpoSamplingData instance) =>
    <String, dynamic>{
      'sampling_id': instance.samplingId,
      'registration_id': instance.registrationId,
      'oil_temp': instance.oilTemp,
      'visual_color': instance.visualColor,
      'photos': instance.photos,
    };

CpoSamplingPhoto _$CpoSamplingPhotoFromJson(Map<String, dynamic> json) =>
    CpoSamplingPhoto(
      url: json['url'] as String?,
      path: json['path'] as String?,
      sequence: (json['sequence'] as num?)?.toInt(),
    );

Map<String, dynamic> _$CpoSamplingPhotoToJson(CpoSamplingPhoto instance) =>
    <String, dynamic>{
      'url': instance.url,
      'path': instance.path,
      'sequence': instance.sequence,
    };
