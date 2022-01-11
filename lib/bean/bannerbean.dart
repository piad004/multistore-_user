class BannerDetails {
  dynamic banner_id;
  dynamic banner_image;
  dynamic vendor_id;
  dynamic vendor_name;
  dynamic distance;

  BannerDetails(this.banner_id, this.banner_image, this.vendor_id, this.vendor_name, this.distance);

  factory BannerDetails.fromJson(dynamic json) {
    return BannerDetails(json['banner_id'], json['banner_image'], json['vendor_id'], json['vendor_name'], json['distance']);
  }

  @override
  String toString() {
    return 'BannerDetails{banner_id: $banner_id, banner_image: $banner_image, vendor_id: $vendor_id, vendor_name: $vendor_name, distance: $distance}';
  }
}
