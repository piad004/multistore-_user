class BestDeal {

  dynamic vendor_id;
  dynamic vendor_name;
  dynamic distance;
  dynamic logo;
  dynamic percentage;
  dynamic vendor_category_id;
  dynamic vendor_phone;
  dynamic delivery_range;
  dynamic online_status;
  dynamic vendor_loc;
  dynamic about;
  dynamic ui_type;


  BestDeal(
      this.vendor_id,
      this.vendor_name,
      this.distance,
      this.logo,
      this.percentage,
      this.vendor_category_id,
      this.vendor_phone,
      this.delivery_range,
      this.online_status,
      this.vendor_loc,
      this.about,
      this.ui_type);

  factory BestDeal.fromJson(dynamic json){
    return BestDeal(json['vendor_id'], json['vendor_name'], json['distance'], json['logo'], json['percentage'], json['vendor_category_id'],
        json['vendor_phone'],json['delivery_range'],json['online_status'],json['vendor_loc'],json['about'],json['ui_type']);
  }

  @override
  String toString() {
    return 'BestDeal{vendor_id: $vendor_id, vendor_name: $vendor_name,distance: $distance, logo: $logo, percentage: $percentage'
         'vendor_category_id: $vendor_category_id, vendor_phone: $vendor_phone, delivery_range: $delivery_range, online_status: $online_status,'
    ' vendor_loc: $vendor_loc, about: $about, ui_type: $ui_type}';
  }
}