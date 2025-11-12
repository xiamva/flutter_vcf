// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lab_detail_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LabDetailResponse _$LabDetailResponseFromJson(Map<String, dynamic> json) =>
    LabDetailResponse(
      success: json['success'] as bool,
      message: json['message'] as String?,
      data: json['data'] == null
          ? null
          : LabDetailData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LabDetailResponseToJson(LabDetailResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'data': instance.data,
    };

LabDetailData _$LabDetailDataFromJson(Map<String, dynamic> json) =>
    LabDetailData(
      ffa: json['ffa'] as String?,
      moisture: json['moisture'] as String?,
      dobi: json['dobi'] as String?,
      iv: json['iv'] as String?,
      remarks: json['remarks'] as String?,
      status: json['status'] as String?,
    );

Map<String, dynamic> _$LabDetailDataToJson(LabDetailData instance) =>
    <String, dynamic>{
      'ffa': instance.ffa,
      'moisture': instance.moisture,
      'dobi': instance.dobi,
      'iv': instance.iv,
      'remarks': instance.remarks,
      'status': instance.status,
    };
