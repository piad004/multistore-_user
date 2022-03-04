class BannerDetails {
  dynamic banner_id;
  dynamic banner_image;
  dynamic vendor_id;
  dynamic vendor_name;
  dynamic distance;
  dynamic vendor_logo;
  dynamic vendor_category_id;
  dynamic vendor_phone;
  dynamic delivery_range;
  dynamic online_status;
  dynamic vendor_loc;
  dynamic about;
  dynamic ui_type;

  BannerDetails(this.banner_id, this.banner_image, this.vendor_id, this.vendor_name, this.distance,this.vendor_logo,
      this.vendor_category_id,
      this.vendor_phone,
      this.delivery_range,
      this.online_status,
      this.vendor_loc,
      this.about,
      this.ui_type);

  factory BannerDetails.fromJson(dynamic json) {
    return BannerDetails(json['banner_id'], json['banner_image'], json['vendor_id'], json['vendor_name'], json['distance'],
        json['vendor_logo'], json['vendor_category_id'],json['vendor_phone'], json['delivery_range'], json['online_status'],
        json['vendor_loc'],json['about'],json['ui_type']);
  }

  @override
  String toString() {
    return 'BannerDetails{banner_id: $banner_id, banner_image: $banner_image, vendor_id: $vendor_id, vendor_name: $vendor_name, distance: $distance,'
        'vendor_logo: $vendor_logo, vendor_category_id: $vendor_category_id, vendor_phone: $vendor_phone, delivery_range: $delivery_range,'
        ' online_status: $online_status,vendor_loc: $vendor_loc, about: $about, ui_type: $ui_type}';
  }
}
