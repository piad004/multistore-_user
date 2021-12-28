class NearStores{

  dynamic vendor_name;
  dynamic vendor_phone;
  dynamic vendor_id;
  dynamic vendor_logo;
  dynamic vendor_category_id;
  dynamic distance;
  dynamic lat;
  dynamic lng;
  dynamic delivery_range;
  dynamic online_status;
  dynamic vendor_loc;
  dynamic about;

  NearStores(this.vendor_name, this.vendor_phone, this.vendor_id,
      this.vendor_logo, this.vendor_category_id,this.distance,this.lat,this.lng,this.delivery_range,this.online_status,this.vendor_loc,this.about);

  factory NearStores.fromJson(dynamic json) {
    return NearStores(json['vendor_name'], json['vendor_phone'], json['vendor_id'],json['vendor_logo'],json['vendor_category_id'],json['distance'],json['lat'],json['lng'],json['delivery_range'],json['online_status'],json['vendor_loc'],json['about']);
  }

  @override
  String toString() {
    return '{vendor_name: $vendor_name, vendor_phone: $vendor_phone, vendor_id: $vendor_id, vendor_logo: $vendor_logo, vendor_category_id: $vendor_category_id, distance: $distance, lat: $lat, lng: $lng, delivery_range: $delivery_range, online_status: $online_status, vendor_loc: $vendor_loc, about: $about}';
  }
}