// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

part 'unloading_cpo_model.g.dart';

@JsonSerializable()
class UnloadingCpoModel {
  final String? registration_id;
  final String? wb_ticket_no;
  final String? plate_number;
  final String? driver_name;
  final String? vendor_code;
  final String? vendor_name;
  final String? commodity_code;
  final String? commodity_name;
  final String? transporter_name;
  final String? regist_status;
  final String? unloading_status;

  final String? bruto_weight;
  final String? vendor_ffa;
  final String? vendor_moisture;
  final String? created_at;

  // --- NEW FIELDS FROM BACKEND ---
  final String? unloading_id;
  final int? tank_id;
  final String? tank_code;
  final String? tank_name;
  final int? hole_id;
  final String? hole_code;
  final String? hole_name;

  final String? start_time;
  final String? end_time;
  final int? duration_minutes;

  final bool? has_unloading_data;

  final List<UnloadingCpoPhoto>? photos;

  UnloadingCpoModel({
    this.registration_id,
    this.wb_ticket_no,
    this.plate_number,
    this.driver_name,
    this.vendor_code,
    this.vendor_name,
    this.commodity_code,
    this.commodity_name,
    this.transporter_name,
    this.regist_status,
    this.unloading_status,
    this.bruto_weight,
    this.vendor_ffa,
    this.vendor_moisture,
    this.created_at,
    this.unloading_id,
    this.tank_id,
    this.tank_code,
    this.tank_name,
    this.hole_id,
    this.hole_code,
    this.hole_name,
    this.start_time,
    this.end_time,
    this.duration_minutes,
    this.has_unloading_data,
    this.photos,
  });

  factory UnloadingCpoModel.fromJson(Map<String, dynamic> json) =>
      _$UnloadingCpoModelFromJson(json);

  Map<String, dynamic> toJson() => _$UnloadingCpoModelToJson(this);
}

@JsonSerializable()
class UnloadingCpoPhoto {
  final String? photo_id;
  final int? sequence;
  final String? path;
  final String? url;
  final String? taken_at;

  UnloadingCpoPhoto({
    this.photo_id,
    this.sequence,
    this.path,
    this.url,
    this.taken_at,
  });

  factory UnloadingCpoPhoto.fromJson(Map<String, dynamic> json) =>
      _$UnloadingCpoPhotoFromJson(json);

  Map<String, dynamic> toJson() => _$UnloadingCpoPhotoToJson(this);
}
