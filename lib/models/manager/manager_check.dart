import 'package:json_annotation/json_annotation.dart';
import 'manager_check_photo.dart';

part 'manager_check.g.dart';

@JsonSerializable()
class ManagerCheck {
  final String? check_id;
  final String? process_id;
  final String? ticket_id;
  final String? commodity;
  final String? stage;
  final String? check_status;
  final String? remarks;
  @JsonKey(fromJson: _toDouble)
  final double? mgr_ffa;
  @JsonKey(fromJson: _toDouble)
  final double? mgr_moisture;
  @JsonKey(fromJson: _toDouble)
  final double? mgr_dobi;
  @JsonKey(fromJson: _toDouble)
  final double? mgr_iv;
  @JsonKey(fromJson: _toDouble)
  final double? mgr_dirt;
  @JsonKey(fromJson: _toDouble)
  final double? mgr_oil_content;
  final int? mgr_tank_id;
  final int? mgr_hole_id;
  final String? checked_at;
  final String? checked_by;
  final List<ManagerCheckPhoto>? photos;

  ManagerCheck({
    this.check_id,
    this.process_id,
    this.ticket_id,
    this.commodity,
    this.stage,
    this.check_status,
    this.remarks,
    this.mgr_ffa,
    this.mgr_moisture,
    this.mgr_dobi,
    this.mgr_iv,
    this.mgr_dirt,
    this.mgr_oil_content,
    this.mgr_tank_id,
    this.mgr_hole_id,
    this.checked_at,
    this.checked_by,
    this.photos,
  });

  factory ManagerCheck.fromJson(Map<String, dynamic> json) =>
      _$ManagerCheckFromJson(json);
  Map<String, dynamic> toJson() => _$ManagerCheckToJson(this);

  static double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }
}
