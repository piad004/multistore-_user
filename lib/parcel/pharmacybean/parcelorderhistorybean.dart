class TodayOrderParcel {
  dynamic parcel_id;
  dynamic source_address_id;
  dynamic destination_address_id;
  dynamic cart_id;
  dynamic user_id;
  dynamic vendor_id;
  dynamic weight;
  dynamic length;
  dynamic height;
  dynamic width;
  dynamic pickup_time;
  dynamic pickup_date;
  dynamic city_id;
  dynamic charges;
  dynamic distance;
  dynamic payment_method;
  dynamic order_status;
  dynamic payment_status;
  dynamic wallet;
  dynamic dboy_id;
  dynamic user_name;
  dynamic user_email;
  dynamic user_phone;
  dynamic source_pincode;
  dynamic source_houseno;
  dynamic source_landmark;
  dynamic source_add;
  dynamic source_state;
  dynamic source_city;
  dynamic destination_pincode;
  dynamic destination_houseno;
  dynamic destination_landmark;
  dynamic destination_add;
  dynamic destination_state;
  dynamic destination_city;
  dynamic city_name;
  dynamic vendor_name;
  dynamic vendor_phone;
  dynamic vendor_loc;
  dynamic delivery_boy_id;
  dynamic delivery_boy_name;
  dynamic delivery_boy_phone;
  dynamic delivery_boy_pass;
  dynamic delivery_boy_status;
  dynamic parcel_description;
  dynamic source_lat;
  dynamic source_lng;
  dynamic source_phone;
  dynamic source_name;
  dynamic destination_lat;
  dynamic destination_lng;
  dynamic destination_phone;
  dynamic destination_name;
  dynamic lat;
  dynamic lng;

  TodayOrderParcel(
      this.parcel_id,
      this.source_address_id,
      this.destination_address_id,
      this.cart_id,
      this.user_id,
      this.vendor_id,
      this.weight,
      this.length,
      this.height,
      this.width,
      this.pickup_time,
      this.pickup_date,
      this.city_id,
      this.charges,
      this.distance,
      this.payment_method,
      this.order_status,
      this.payment_status,
      this.wallet,
      this.dboy_id,
      this.user_name,
      this.user_email,
      this.user_phone,
      this.source_pincode,
      this.source_houseno,
      this.source_landmark,
      this.source_add,
      this.source_state,
      this.source_city,
      this.destination_pincode,
      this.destination_houseno,
      this.destination_landmark,
      this.destination_add,
      this.destination_state,
      this.destination_city,
      this.city_name,
      this.vendor_name,
      this.vendor_phone,
      this.vendor_loc,
      this.delivery_boy_id,
      this.delivery_boy_name,
      this.delivery_boy_phone,
      this.delivery_boy_pass,
      this.delivery_boy_status,
      this.parcel_description,
      this.source_lat,
      this.source_lng,
      this.source_phone,
      this.source_name,
      this.destination_lat,
      this.destination_lng,
      this.destination_phone,
      this.destination_name,
      this.lat,
      this.lng,
      );

  factory TodayOrderParcel.fromJson(dynamic json) {
    return TodayOrderParcel(
        json['parcel_id'],
        json['source_address_id'],
        json['destination_address_id'],
        json['cart_id'],
        json['user_id'],
        json['vendor_id'],
        json['weight'],
        json['length'],
        json['height'],
        json['width'],
        json['pickup_time'],
        json['pickup_date'],
        json['city_id'],
        json['charges'],
        json['distance'],
        json['payment_method'],
        json['order_status'],
        json['payment_status'],
        json['wallet'],
        json['dboy_id'],
        json['user_name'],
        json['user_email'],
        json['user_phone'],
        json['source_pincode'],
        json['source_houseno'],
        json['source_landmark'],
        json['source_add'],
        json['source_state'],
        json['source_city'],
        json['destination_pincode'],
        json['destination_houseno'],
        json['destination_landmark'],
        json['destination_add'],
        json['destination_state'],
        json['destination_city'],
        json['city_name'],
        json['vendor_name'],
        json['vendor_phone'],
        json['vendor_loc'],
        json['delivery_boy_id'],
        json['delivery_boy_name'],
        json['delivery_boy_phone'],
        json['delivery_boy_pass'],
        json['delivery_boy_status'],
        json['description'],
        json['source_lat'],
        json['source_lng'],
        json['source_phone'],
        json['source_name'],
        json['destination_lat'],
        json['destination_lng'],
        json['destination_phone'],
        json['destination_name'],
        json['lat'],
        json['lng']
    );
  }

  @override
  String toString() {
    return '{parcel_id: $parcel_id, source_address_id: $source_address_id, destination_address_id: $destination_address_id, cart_id: $cart_id, user_id: $user_id, vendor_id: $vendor_id, weight: $weight, length: $length, height: $height, width: $width, pickup_time: $pickup_time, pickup_date: $pickup_date, city_id: $city_id, charges: $charges, distance: $distance, payment_method: $payment_method, order_status: $order_status, payment_status: $payment_status, wallet: $wallet, dboy_id: $dboy_id, user_name: $user_name, user_email: $user_email, user_phone: $user_phone, source_pincode: $source_pincode, source_houseno: $source_houseno, source_landmark: $source_landmark, source_add: $source_add, source_state: $source_state, source_city: $source_city, destination_pincode: $destination_pincode, destination_houseno: $destination_houseno, destination_landmark: $destination_landmark, destination_add: $destination_add, destination_state: $destination_state, destination_city: $destination_city, city_name: $city_name, vendor_name: $vendor_name, vendor_phone: $vendor_phone, vendor_loc: $vendor_loc, delivery_boy_id: $delivery_boy_id, delivery_boy_name: $delivery_boy_name, delivery_boy_phone: $delivery_boy_phone, delivery_boy_pass: $delivery_boy_pass, delivery_boy_status: $delivery_boy_status, parcel_description: $parcel_description, source_lat: $source_lat, source_lng: $source_lng, source_phone: $source_phone, source_name: $source_name, destination_lat: $destination_lat, destination_lng: $destination_lng, destination_phone: $destination_phone, destination_name: $destination_name, lat: $lat, lng: $lng}';
  }
}
