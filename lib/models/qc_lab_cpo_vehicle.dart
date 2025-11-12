import 'package:json_annotation/json_annotation.dart';

part 'qc_lab_cpo_vehicle.g.dart';

@JsonSerializable()
class QcLabCpoVehicle {
  final String? registration_id;
  final String? wb_ticket_no;
  final String? plate_number;
  final String? driver_name;
  final String? vendor_code;
  final String? vendor_name;
  final String? commodity_code;
  final String? commodity_name;
  final String? regist_status;
  final String? lab_status;

  @JsonKey(fromJson: _toDouble)
  final double? ffa;
  @JsonKey(fromJson: _toDouble)
  final double? moisture;
  @JsonKey(fromJson: _toDouble)
  final double? dobi;
  @JsonKey(fromJson: _toDouble)
  final double? iv;

  final String? remarks;

  QcLabCpoVehicle({
    this.registration_id,
    this.wb_ticket_no,
    this.plate_number,
    this.driver_name,
    this.vendor_code,
    this.vendor_name,
    this.commodity_code,
    this.commodity_name,
    this.regist_status,
    this.lab_status,
    this.ffa,
    this.moisture,
    this.dobi,
    this.iv,
    this.remarks,
  });

  factory QcLabCpoVehicle.fromJson(Map<String, dynamic> json) =>
      _$QcLabCpoVehicleFromJson(json);

  Map<String, dynamic> toJson() => _$QcLabCpoVehicleToJson(this);


  static double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }
}
