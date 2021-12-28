class VendorBanner {

  dynamic banner_id;
  dynamic cityadmin_id;
  dynamic banner_name;
  dynamic bannerloc_id;
  dynamic banner_image;
  dynamic keyword;
  dynamic created_at;
  dynamic updated_at;
  dynamic vendor_id;

  VendorBanner(
      this.banner_id,
      this.cityadmin_id,
      this.banner_name,
      this.bannerloc_id,
      this.banner_image,
      this.keyword,
      this.created_at,
      this.updated_at,
      this.vendor_id);

  factory VendorBanner.fromJson(dynamic json){
    return VendorBanner(json['banner_id'], json['cityadmin_id'], json['banner_name'], json['bannerloc_id'],
        json['banner_image'], json['keyword'], json['created_at'], json['updated_at'], json['vendor_id']);
  }

  @override
  String toString() {
    return 'VendorBanner{banner_id: $banner_id, cityadmin_id: $cityadmin_id, banner_name: $banner_name, bannerloc_id: $bannerloc_id, banner_image: $banner_image, keyword: $keyword, created_at: $created_at, updated_at: $updated_at, vendor_id: $vendor_id}';
  }
}