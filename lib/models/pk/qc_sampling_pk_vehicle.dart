// ignore_for_file: non_constant_identifier_names
import 'package:json_annotation/json_annotation.dart';

part 'qc_sampling_pk_vehicle.g.dart';

@JsonSerializable()
class QcSamplingPkVehicle {
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
  final bool? has_sampling_data;
  final bool? is_resampling;
  final num? bruto_weight;
  final num? vendor_ffa;
  final num? vendor_moisture;
  final String? created_at;

  QcSamplingPkVehicle({
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
    this.has_sampling_data,
    this.is_resampling,
    this.bruto_weight,
    this.vendor_ffa,
    this.vendor_moisture,
    this.created_at,
  });

  factory QcSamplingPkVehicle.fromJson(Map<String, dynamic> json) =>
      _$QcSamplingPkVehicleFromJson(json);

  Map<String, dynamic> toJson() => _$QcSamplingPkVehicleToJson(this);
}
