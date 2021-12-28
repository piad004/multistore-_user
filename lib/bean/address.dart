class CityList {

  dynamic city_id;
  dynamic city_name;

  CityList(this.city_id, this.city_name);


  factory CityList.fromJson(dynamic json){
    return CityList(json['city_id'], json['city_name']);
  }

  @override
  String toString() {
    return 'CityList{city_id: $city_id, city_name: $city_name}';
  }
}

class AreaList {

  dynamic area_id;
  dynamic area_name;

  AreaList(this.area_id, this.area_name);

  factory AreaList.fromJson(dynamic json){
    return AreaList(json['area_id'], json['area_name']);
  }

  @override
  String toString() {
    return 'AreaList{area_id: $area_id, area_name: $area_name}';
  }
}


class ShowAddress{

  dynamic address_id;
  dynamic user_id;
  dynamic city_id;
  dynamic area_id;
  dynamic address;
  dynamic lat;
  dynamic lng;
  dynamic created_at;
  dynamic updated_at;
  dynamic user_name;
  dynamic user_number;
  dynamic select_status;
  dynamic cityadmin_id;
  dynamic area_name;
  dynamic delivery_charge;
  dynamic cod;
  dynamic vendor_id;
  dynamic houseno;
  dynamic pincode;
  dynamic state;
  dynamic type;
  dynamic street;


  ShowAddress(
      this.address_id,
      this.user_id,
      this.city_id,
      this.area_id,
      this.address,
      this.lat,
      this.lng,
      this.created_at,
      this.updated_at,
      this.user_name,
      this.user_number,
      this.select_status,
      this.cityadmin_id,
      this.area_name,
      this.delivery_charge,
      this.cod,
      this.vendor_id,
      this.houseno,
      this.pincode,
      this.state,
      this.type,
      this.street);


  factory ShowAddress.fromJson(dynamic json){
    return ShowAddress(json['address_id'], json['user_id'], json['city_id'], json['area_id'], json['address'], json['lat'], json['lng'], json['created_at'], json['updated_at'], json['user_name'], json['user_number'], json['select_status'], json['cityadmin_id'], json['area_name'], json['delivery_charge'], json['cod'], json['vendor_id'],json['houseno'],json['pincode'],json['state'],json['type'],json['street']);
  }


  @override
  String toString() {
    return 'ShowAddress{address_id: $address_id, user_id: $user_id, city_id: $city_id, area_id: $area_id, address: $address, lat: $lat, lng: $lng, created_at: $created_at, updated_at: $updated_at, user_name: $user_name, user_number: $user_number, select_status: $select_status, cityadmin_id: $cityadmin_id, area_name: $area_name, delivery_charge: $delivery_charge, cod: $cod, vendor_id: $vendor_id, houseno: $houseno, pincode: $pincode, state: $state, type: $type, street: $street}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ShowAddress &&
              runtimeType == other.runtimeType &&
              '$select_status' == '${other.select_status}';

  @override
  int get hashCode => select_status.hashCode;
}

class AddressSelected {
  // AddressSelected({
  //   this.status,
  //   this.message,
  //   this.data,
  //   this.deliveryCharge,
  // });

  dynamic status;
  dynamic message;
  ShowAddressNew data;
  // List<DeliveryCharge> deliveryCharge;

  AddressSelected(this.status, this.message, this.data);

  factory AddressSelected.fromJson(dynamic json) {
    var jsonD2 = json['data'] as List;
    if(jsonD2!=null){
      List<ShowAddressNew> tagObjs = jsonD2.map((e) => ShowAddressNew.fromJson(e)).toList();
      print('y ${tagObjs.toString()}');
      List<ShowAddressNew> tagObjs1 = tagObjs.where((element) => element.selectStatus.toString()=='1').toList();
      print('y1 ${tagObjs1.toString()}');
      if(tagObjs1!=null && tagObjs1.length>0){
        return AddressSelected(json['status'], json['message'], tagObjs1[0]);
      }else{
        return AddressSelected(json['status'], json['message'], null);
      }
    }else{
      return AddressSelected(json['status'], json['message'], null);
    }
  }

  @override
  String toString() {
    return '{status: $status, message: $message, data: $data}';
  }
}

class ShowAddressNew {
  dynamic addressId;
  dynamic userId;
  dynamic cityId;
  dynamic areaId;
  dynamic address;
  dynamic lat;
  dynamic lng;
  dynamic createdAt;
  dynamic updatedAt;
  dynamic userName;
  dynamic userNumber;
  dynamic selectStatus;
  dynamic houseno;
  dynamic pincode;
  dynamic state;
  dynamic street;
  dynamic vendor_area_id;
  dynamic delivery_charge;
  dynamic cod;
  dynamic vendor_id;
  dynamic type;

  ShowAddressNew(
      this.addressId,
      this.userId,
      this.cityId,
      this.areaId,
      this.address,
      this.lat,
      this.lng,
      this.createdAt,
      this.updatedAt,
      this.userName,
      this.userNumber,
      this.selectStatus,
      this.houseno,
      this.pincode,
      this.state,
      this.street,
      this.vendor_area_id,
      this.delivery_charge,
      this.cod,
      this.vendor_id,
      this.type);

  factory ShowAddressNew.fromJson(dynamic json) {
    return ShowAddressNew(
        json['address_id'],
        json['user_id'],
        json['city_id'],
        json['area_id'],
        json['address'],
        json['lat'],
        json['lng'],
        json['created_at'],
        json['updated_at'],
        json['user_name'],
        json['user_number'],
        json['select_status'],
        json['houseno'],
        json['pincode'],
        json['state'],
        json['street'],
        json['vendor_area_id'],
        json['delivery_charge'],
        json['cod'],
        json['vendor_id'],
        json['type']);
  }

  @override
  String toString() {
    return '{addressId: $addressId, userId: $userId, cityId: $cityId, areaId: $areaId, address: $address, lat: $lat, lng: $lng, createdAt: $createdAt, updatedAt: $updatedAt, userName: $userName, userNumber: $userNumber, selectStatus: $selectStatus, houseno: $houseno, pincode: $pincode, state: $state, street: $street, vendor_area_id: $vendor_area_id, delivery_charge: $delivery_charge, cod: $cod, vendor_id: $vendor_id, type: $type}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ShowAddressNew &&
              runtimeType == other.runtimeType &&
              '$selectStatus' == '${other.selectStatus}';

  @override
  int get hashCode => selectStatus.hashCode;
}