

class ChargeListBean {

  dynamic charge_id;
  dynamic city_id;
  dynamic city_from;
  dynamic city_name;
  dynamic city_to;
  dynamic parcel_charge;
  dynamic charge_description;
  dynamic vendor_id;
  dynamic updated_at;
  dynamic created_at;

  ChargeListBean(
      this.charge_id,
      this.city_id,
      this.city_from,
      this.city_name,
      this.city_to,
      this.parcel_charge,
      this.charge_description,
      this.vendor_id,
      this.updated_at,
      this.created_at);

  factory ChargeListBean.fromJson(dynamic json){
    return ChargeListBean(json['charge_id'], json['city_id'], json['city_from'], json['city_name'], json['city_to'], json['parcel_charge'], json['charge_description'], json['vendor_id'], json['updated_at'], json['created_at']);
  }

  @override
  String toString() {
    return '{charge_id: $charge_id, city_id: $city_id, city_from: $city_from, cityname: $city_name, city_to: $city_to, parcel_charge: $parcel_charge, charge_description: $charge_description, vendor_id: $vendor_id, updated_at: $updated_at, created_at: $created_at}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChargeListBean && runtimeType == other.runtimeType && city_name == other.city_name;

  @override
  int get hashCode => city_name.hashCode;
}