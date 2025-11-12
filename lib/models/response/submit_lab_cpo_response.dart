import 'package:json_annotation/json_annotation.dart';

part 'submit_lab_cpo_response.g.dart';

@JsonSerializable()
class SubmitLabCpoResponse {
  final bool success;
  final String? message;
  final LabCpoData? data;

  SubmitLabCpoResponse({
    required this.success,
    this.message,
    this.data,
  });

  factory SubmitLabCpoResponse.fromJson(Map<String, dynamic> json) =>
      _$SubmitLabCpoResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SubmitLabCpoResponseToJson(this);
}

@JsonSerializable()
class LabCpoData {
  @JsonKey(name: 'registration_id')
  final String? registrationId;

  @JsonKey(fromJson: _toDouble)
  final double? ffa;
  @JsonKey(fromJson: _toDouble)
  final double? moisture;
  @JsonKey(fromJson: _toDouble)
  final double? dobi;
  @JsonKey(fromJson: _toDouble)
  final double? iv;

  final String? remarks;
  final List<LabCpoPhoto>? photos;

  LabCpoData({
    this.registrationId,
    this.ffa,
    this.moisture,
    this.dobi,
    this.iv,
    this.remarks,
    this.photos,
  });

  factory LabCpoData.fromJson(Map<String, dynamic> json) =>
      _$LabCpoDataFromJson(json);

  Map<String, dynamic> toJson() => _$LabCpoDataToJson(this);

  
  static double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }
}

@JsonSerializable()
class LabCpoPhoto {
  final String? url;
  final String? path;

  LabCpoPhoto({this.url, this.path});

  factory LabCpoPhoto.fromJson(Map<String, dynamic> json) =>
      _$LabCpoPhotoFromJson(json);

  Map<String, dynamic> toJson() => _$LabCpoPhotoToJson(this);
}
