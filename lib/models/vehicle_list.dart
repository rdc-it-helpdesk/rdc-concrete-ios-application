class VehicleList {
  final int status; // Add status if needed
  final String vehiclenumber;
  final int driverrid; // Change to int
  final String drivername;
  final String drivermobile;

  VehicleList({
    required this.status,
    required this.vehiclenumber,
    required this.driverrid,
    required this.drivername,
    required this.drivermobile,
  });

  factory VehicleList.fromJson(Map<String, dynamic> json) {
    return VehicleList(
      status: json['status'] ?? 0, // Ensure default value
      vehiclenumber: json['vehiclenumber'] ?? '',
      driverrid:
          json['driverrid'] is int
              ? json['driverrid']
              : int.tryParse(json['driverrid'].toString()) ?? 0,
      drivername: json['drivername'] ?? '',
      drivermobile: json['drivermobile'] ?? '',
    );
  }
}
