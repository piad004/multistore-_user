class ProfileBean {

  dynamic user_id;
  dynamic user_name;
  dynamic user_email;
  dynamic user_image;
  dynamic user_phone;
  dynamic user_password;
  dynamic device_id;
  dynamic wallet_credits;
  dynamic first_recharge_coupon;
  dynamic created_at;
  dynamic updated_at;
  dynamic otp;
  dynamic phone_verified;
  dynamic address_id;
  dynamic city_id;
  dynamic area_id;
  dynamic address;
  dynamic lat;
  dynamic lng;
  dynamic user_number;
  dynamic select_status;


  ProfileBean(this.user_id,
      this.user_name,
      this.user_email,
      this.user_image,
      this.user_phone,
      this.user_password,
      this.device_id,
      this.wallet_credits,
      this.first_recharge_coupon,
      this.created_at,
      this.updated_at,
      this.otp,
      this.phone_verified,
      this.address_id,
      this.city_id,
      this.area_id,
      this.address,
      this.lat,
      this.lng,
      this.user_number,
      this.select_status);


  factory ProfileBean.fromJson(dynamic json){
    return ProfileBean(
        json['user_id'],
        json['user_name'],
        json['user_email'],
        json['user_image'],
        json['user_phone'],
        json['user_password'],
        json['device_id'],
        json['wallet_credits'],
        json['first_recharge_coupon'],
        json['created_at'],
        json['updated_at'],
        json['otp'],
        json['phone_verified'],
        json['address_id'],
        json['city_id'],
        json['area_id'],
        json['address'],
        json['lat'],
        json['lng'],
        json['user_number'],
        json['select_status']);
  }

  @override
  String toString() {
    return 'ProfileBean{user_id: $user_id, user_name: $user_name, user_email: $user_email, user_image: $user_image, user_phone: $user_phone, user_password: $user_password, device_id: $device_id, wallet_credits: $wallet_credits, first_recharge_coupon: $first_recharge_coupon, created_at: $created_at, updated_at: $updated_at, otp: $otp, phone_verified: $phone_verified, address_id: $address_id, city_id: $city_id, area_id: $area_id, address: $address, lat: $lat, lng: $lng, user_number: $user_number, select_status: $select_status}';
  }
}