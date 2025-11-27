import 'package:json_annotation/json_annotation.dart';

part 'qc_sampling_pk_vehicles_response.g.dart';

@JsonSerializable()
class QcSamplingPkVehiclesResponse {
  final bool success;
  final String message;
  final List<QcSamplingPkVehicle>? data;
  final int? total;

  QcSamplingPkVehiclesResponse({
    required this.success,
    required this.message,
    this.data,
    this.total,
  });

  factory QcSamplingPkVehiclesResponse.fromJson(Map<String, dynamic> json) =>
      _$QcSamplingPkVehiclesResponseFromJson(json);
}

@JsonSerializable()
class QcSamplingPkVehicle {
  final String registration_id;
  final String wb_ticket_no;
  final String plate_number;
  final String driver_name;
  final String vendor_code;
  final String vendor_name;
  final String commodity_code;
  final String commodity_name;
  final String transporter_name;
  final String regist_status;
  final String? wb_in_tap_out;
  final bool has_sampling_data;
  final bool is_resampling;
  final String? bruto_weight;
  final String? vendor_ffa;
  final String? vendor_moisture;
  final String? created_at;

  QcSamplingPkVehicle({
    required this.registration_id,
    required this.wb_ticket_no,
    required this.plate_number,
    required this.driver_name,
    required this.vendor_code,
    required this.vendor_name,
    required this.commodity_code,
    required this.commodity_name,
    required this.transporter_name,
    required this.regist_status,
    this.wb_in_tap_out,
    required this.has_sampling_data,
    required this.is_resampling,
    this.bruto_weight,
    this.vendor_ffa,
    this.vendor_moisture,
    this.created_at,
  });

  factory QcSamplingPkVehicle.fromJson(Map<String, dynamic> json) =>
      _$QcSamplingPkVehicleFromJson(json);
}
