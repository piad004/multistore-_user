class BestRated {

  dynamic vendor_id;
  dynamic vendor_name;
  dynamic distance;
  dynamic logo;
  dynamic rating;
  dynamic vendor_category_id;
  dynamic vendor_phone;
  dynamic delivery_range;
  dynamic online_status;
  dynamic vendor_loc;
  dynamic about;
  dynamic ui_type;

  BestRated(
      this.vendor_id,
      this.vendor_name,
      this.distance,
      this.logo,
      this.rating,
      this.vendor_category_id,
      this.vendor_phone,
      this.delivery_range,
      this.online_status,
      this.vendor_loc,
      this.about,
      this.ui_type);

  factory BestRated.fromJson(dynamic json){
    return BestRated(json['vendor_id'], json['vendor_name'],json['distance'], json['logo'], json['rating'], json['vendor_category_id'],
        json['vendor_phone'],json['delivery_range'],json['online_status'],json['vendor_loc'],json['about'],json['ui_type']);
  }

  @override
  String toString() {
    return 'BestRated{vendor_id: $vendor_id, vendor_name: $vendor_name, distance: $distance, logo: $logo, rating: $rating, '
        'vendor_category_id: $vendor_category_id, vendor_phone: $vendor_phone, delivery_range: $delivery_range, online_status: $online_status,'
        ' vendor_loc: $vendor_loc, about: $about, ui_type: $ui_type}';
  }
}