import 'package:json_annotation/json_annotation.dart';
import '../manager_check_detail.dart';

part 'manager_check_detail_response.g.dart';

@JsonSerializable()
class ManagerCheckDetailResponse {
  final bool? success;
  final String? message;
  final ManagerCheckDetail? data;

  ManagerCheckDetailResponse({
    this.success,
    this.message,
    this.data,
  });

  factory ManagerCheckDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$ManagerCheckDetailResponseFromJson(json);
}
