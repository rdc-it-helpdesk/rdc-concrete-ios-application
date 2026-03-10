class LocationPoJo {
  final int status;
  final String sitename;
  final String latitude;
  final String longitude;

  LocationPoJo({
    required this.status,
    required this.sitename,
    required this.latitude,
    required this.longitude,
  });

  factory LocationPoJo.fromJson(Map<String, dynamic> json) {
    return LocationPoJo(
      status: json['status'],
      sitename: json['Sitename'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'Sitename': sitename,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
