import 'package:json_annotation/json_annotation.dart';
import '../unloading_pk_model.dart';

part 'unloading_pk_response.g.dart';

@JsonSerializable()
class UnloadingPkResponse {
  final bool success;
  final String? message;
  final List<UnloadingPkModel> data;
  final int? total;

  UnloadingPkResponse({
    required this.success,
    this.message,
    required this.data,
    this.total,
  });

  factory UnloadingPkResponse.fromJson(Map<String, dynamic> json) =>
      _$UnloadingPkResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UnloadingPkResponseToJson(this);
}
