// class LocationList {
//   final String locationName;
//
//   LocationList({required this.locationName});
//
//   factory LocationList.fromJson(Map<String, dynamic> json) {
//     return LocationList(
//       locationName: json['locationname'],
//     );
//   }
// }
class LocationList {
  final String locationName;
  final int locationId;

  LocationList({required this.locationName, required this.locationId});

  factory LocationList.fromJson(Map<String, dynamic> json) {
    return LocationList(
      locationName: json['locationname'],
      locationId: json['locationid'],
    );
  }
}

// class LocationList {
//   String locationName;
//   int locationId;
//
//   LocationList({required this.locationName, required this.locationId});
//
//   factory LocationList.fromJson(Map<String, dynamic> json) {
//     return LocationList(
//       locationName: json['locationname'],
//       locationId: json['locationid'],
//     );
//   }
// }
