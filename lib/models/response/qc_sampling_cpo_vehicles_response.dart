import 'package:json_annotation/json_annotation.dart';
part 'qc_sampling_cpo_vehicles_response.g.dart';

@JsonSerializable()
class QcSamplingCpoVehiclesResponse {
  final bool success;
  final String message;
  final List<QcSamplingCpoVehicle>? data;

  QcSamplingCpoVehiclesResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory QcSamplingCpoVehiclesResponse.fromJson(Map<String, dynamic> json)
      => _$QcSamplingCpoVehiclesResponseFromJson(json);
}

@JsonSerializable()
class QcSamplingCpoVehicle {
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

  QcSamplingCpoVehicle({
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

  factory QcSamplingCpoVehicle.fromJson(Map<String, dynamic> json)
      => _$QcSamplingCpoVehicleFromJson(json);
}
