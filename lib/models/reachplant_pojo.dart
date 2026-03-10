class ReachPlant {
  String? reachplant;
  String? status;

  ReachPlant({this.reachplant, this.status});

  factory ReachPlant.fromJson(Map<String, dynamic> json) {
    return ReachPlant(
      reachplant: json['reachplant'] as String?,
      status: json['status'] as String?,
    );
  }

  // Method to convert a ReachPlant instance to JSON
  Map<String, dynamic> toJson() {
    return {'reachplant': reachplant, 'status': status};
  }
}
