class SiteResponse {
  final int? vId;
  final List<String>? sites;

  SiteResponse({
    required this.vId,
    required this.sites,
  });

  factory SiteResponse.fromJson(Map<String, dynamic> json) {
    return SiteResponse(
      vId: json["v_id"] as int?,
      sites: (json["sites"] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );
  }
}