import 'package:json_annotation/json_annotation.dart';

part 'rain_model.g.dart';

@JsonSerializable(createToJson: false)
class Rain {
  @JsonKey(name: "1h")
  final double? the1H;

  Rain({this.the1H});

  factory Rain.fromJson(Map<String, dynamic> json) => _$RainFromJson(json);
}
