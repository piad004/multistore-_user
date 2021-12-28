

class PharmaBanner{

  dynamic banner_id;
  dynamic banner_image;
  dynamic vendor_id;

  PharmaBanner(this.banner_id, this.banner_image, this.vendor_id);

  factory PharmaBanner.fromJson(dynamic json){
    return PharmaBanner(json['banner_id'], json['banner_image'], json['vendor_id']);
  }

  @override
  String toString() {
    return 'PharmaBanner{banner_id: $banner_id, banner_image: $banner_image, vendor_id: $vendor_id}';
  }
}