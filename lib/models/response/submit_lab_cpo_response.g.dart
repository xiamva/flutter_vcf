// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'submit_lab_cpo_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubmitLabCpoResponse _$SubmitLabCpoResponseFromJson(
  Map<String, dynamic> json,
) => SubmitLabCpoResponse(
  success: json['success'] as bool,
  message: json['message'] as String?,
  data: json['data'] == null
      ? null
      : LabCpoData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$SubmitLabCpoResponseToJson(
  SubmitLabCpoResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data,
};

LabCpoData _$LabCpoDataFromJson(Map<String, dynamic> json) => LabCpoData(
  registrationId: json['registration_id'] as String?,
  ffa: LabCpoData._toDouble(json['ffa']),
  moisture: LabCpoData._toDouble(json['moisture']),
  dobi: LabCpoData._toDouble(json['dobi']),
  iv: LabCpoData._toDouble(json['iv']),
  remarks: json['remarks'] as String?,
  photos: (json['photos'] as List<dynamic>?)
      ?.map((e) => LabCpoPhoto.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$LabCpoDataToJson(LabCpoData instance) =>
    <String, dynamic>{
      'registration_id': instance.registrationId,
      'ffa': instance.ffa,
      'moisture': instance.moisture,
      'dobi': instance.dobi,
      'iv': instance.iv,
      'remarks': instance.remarks,
      'photos': instance.photos,
    };

LabCpoPhoto _$LabCpoPhotoFromJson(Map<String, dynamic> json) =>
    LabCpoPhoto(url: json['url'] as String?, path: json['path'] as String?);

Map<String, dynamic> _$LabCpoPhotoToJson(LabCpoPhoto instance) =>
    <String, dynamic>{'url': instance.url, 'path': instance.path};
