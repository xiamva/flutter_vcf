// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'manager_check_tickets_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ManagerCheckTicketsResponse _$ManagerCheckTicketsResponseFromJson(
  Map<String, dynamic> json,
) => ManagerCheckTicketsResponse(
  success: json['success'] as bool?,
  message: json['message'] as String?,
  data: (json['data'] as List<dynamic>?)
      ?.map((e) => ManagerCheckTicket.fromJson(e as Map<String, dynamic>))
      .toList(),
  total: (json['total'] as num?)?.toInt(),
);

Map<String, dynamic> _$ManagerCheckTicketsResponseToJson(
  ManagerCheckTicketsResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data,
  'total': instance.total,
};
