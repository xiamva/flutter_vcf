// ignore_for_file: non_constant_identifier_names
import 'package:json_annotation/json_annotation.dart';

part 'qc_sampling_vehicle.g.dart';

@JsonSerializable()
class QcSamplingVehicle {
  final String? registration_id;
  final String? wb_ticket_no;
  final String? plate_number;
  final String? driver_name;
  final String? vendor_code;
  final String? vendor_name;
  final String? commodity_code;
  final String? commodity_name;
  final String? regist_status;
  final bool? has_sampling_data;

  QcSamplingVehicle({
    this.registration_id,
    this.wb_ticket_no,
    this.plate_number,
    this.driver_name,
    this.vendor_code,
    this.vendor_name,
    this.commodity_code,
    this.commodity_name,
    this.regist_status,
    this.has_sampling_data,
  });

  factory QcSamplingVehicle.fromJson(Map<String, dynamic> json) =>
      _$QcSamplingVehicleFromJson(json);

  Map<String, dynamic> toJson() => _$QcSamplingVehicleToJson(this);
}
