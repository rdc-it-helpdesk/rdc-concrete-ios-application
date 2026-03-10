class WeighbridgeStatus {
  String weight;

  WeighbridgeStatus({required this.weight});

  factory WeighbridgeStatus.fromJson(Map<String, dynamic> json) {
    return WeighbridgeStatus(weight: json['weight'] as String);
  }

  Map<String, dynamic> toJson() {
    return {'weight': weight};
  }
}
