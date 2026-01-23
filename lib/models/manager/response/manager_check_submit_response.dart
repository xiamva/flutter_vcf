import 'package:json_annotation/json_annotation.dart';
import '../manager_check.dart';

part 'manager_check_submit_response.g.dart';

@JsonSerializable()
class ManagerCheckSubmitResponse {
  final bool? success;
  final String? message;
  final ManagerCheck? data;

  ManagerCheckSubmitResponse({
    this.success,
    this.message,
    this.data,
  });

  factory ManagerCheckSubmitResponse.fromJson(Map<String, dynamic> json) =>
      _$ManagerCheckSubmitResponseFromJson(json);
}
