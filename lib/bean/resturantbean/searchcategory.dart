class SearchMainList{

  dynamic status;
  dynamic message;
  List<StoresRestaurant> stores;
  List<SearchCategory> category;
  List<SearchProuduct> products;


  SearchMainList(this.status, this.message, this.stores, this.category,
      this.products);

  factory SearchMainList.fromJson(dynamic json){
    var tagObjsJsonStore = json['stores'] as List;
    var tagObjsJsonCategory = json['category'] as List;
    var tagObjsJsonSub = json['products'] as List;

    List<StoresRestaurant> _tags = tagObjsJsonStore.map((tagJson) => StoresRestaurant.fromJson(tagJson)).toList();
    if(_tags==null || _tags.length == 0){
      _tags = [];
    }
    List<SearchCategory> _tags2 = tagObjsJsonCategory.map((tagJson) => SearchCategory.fromJson(tagJson)).toList();
    if(_tags2==null || _tags2.length == 0){
      _tags2 = [];
    }
    List<SearchProuduct> _tags3 = tagObjsJsonSub.map((tagJson) => SearchProuduct.fromJson(tagJson)).toList();
    if(_tags3==null || _tags3.length == 0){
      _tags3 = [];
    }


    return SearchMainList(json['status'], json['message'], _tags, _tags2, _tags3);

  }

  @override
  String toString() {
    return 'SearchProduct{status: $status, message: $message, stores: $stores, category: $category}';
  }

}

class SearchCategory{

  dynamic resturant_cat_id;
  dynamic cat_name;
  dynamic cat_image;
  dynamic vendor_id;
  dynamic vendor_name;
  dynamic distance;

  SearchCategory(this.resturant_cat_id, this.cat_name, this.cat_image,
      this.vendor_id, this.vendor_name, this.distance);

  factory SearchCategory.fromJson(dynamic json){
    return SearchCategory(json['resturant_cat_id'], json['cat_name'], json['cat_image'], json['vendor_id'], json['vendor_name'], json['distance']);
  }

  @override
  String toString() {
    return 'SearchCategory{resturant_cat_id: $resturant_cat_id, cat_name: $cat_name, cat_image: $cat_image, vendor_id: $vendor_id, vendor_name: $vendor_name, distance: $distance}';
  }
}


class StoresRestaurant{

  dynamic vendor_id;
  dynamic vendor_name;
  dynamic owner;
  dynamic cityadmin_id;
  dynamic vendor_email;
  dynamic vendor_phone;
  dynamic vendor_logo;
  dynamic vendor_loc;
  dynamic lat;
  dynamic lng;
  dynamic opening_time;
  dynamic closing_time;
  dynamic vendor_pass;
  dynamic created_at;
  dynamic updated_at;
  dynamic vendor_category_id;
  dynamic comission;
  dynamic delivery_range;
  dynamic device_id;
  dynamic otp;
  dynamic phone_verified;
  dynamic ui_type;
  dynamic product_id;
  dynamic subcat_id;
  dynamic distance;
  dynamic online_status;
  dynamic about;

  StoresRestaurant(
      this.vendor_id,
      this.vendor_name,
      this.owner,
      this.cityadmin_id,
      this.vendor_email,
      this.vendor_phone,
      this.vendor_logo,
      this.vendor_loc,
      this.lat,
      this.lng,
      this.opening_time,
      this.closing_time,
      this.vendor_pass,
      this.created_at,
      this.updated_at,
      this.vendor_category_id,
      this.comission,
      this.delivery_range,
      this.device_id,
      this.otp,
      this.phone_verified,
      this.ui_type,
      this.product_id,
      this.subcat_id,
      this.distance,
  this.online_status,
  this.about);

  factory StoresRestaurant.fromJson(dynamic json){
    return StoresRestaurant(json['vendor_id'], json['vendor_name'], json['owner'], json['cityadmin_id'], json['vendor_email'], json['vendor_phone'], json['vendor_logo'], json['vendor_loc'], json['lat'], json['lng'], json['opening_time'], json['closing_time'],
        json['vendor_pass'], json['created_at'], json['updated_at'], json['vendor_category_id'], json['comission'],
        json['delivery_range'], json['device_id'], json['otp'], json['phone_verified'], json['ui_type'], json['product_id'],
        json['subcat_id'], json['distance'],json['online_status'], json['about']);
  }

  @override
  String toString() {
    return '{vendor_id: $vendor_id, vendor_name: $vendor_name, owner: $owner, cityadmin_id: $cityadmin_id, vendor_email: $vendor_email, vendor_phone: $vendor_phone, vendor_logo: $vendor_logo, vendor_loc: $vendor_loc, lat: $lat, lng: $lng, opening_time: $opening_time, closing_time: $closing_time, vendor_pass: $vendor_pass, created_at: $created_at, updated_at: $updated_at, vendor_category_id: $vendor_category_id, comission: $comission, delivery_range: $delivery_range, device_id: $device_id, otp: $otp, phone_verified: $phone_verified, ui_type: $ui_type, product_id: $product_id, subcat_id: $subcat_id, distance: $distance, online_status: $online_status, about: $about}';
  }
}

class SearchProuduct{
  dynamic product_id;
  dynamic subcat_id;
  dynamic product_name;
  dynamic product_image;
  dynamic created_at;
  dynamic vendor_id;
  dynamic updated_at;
  dynamic description;
  dynamic vendor_name;
  List<SearchVaritant> varients;
  List<AddOnsL> addons;

  SearchProuduct(
      this.product_id,
      this.subcat_id,
      this.product_name,
      this.product_image,
      this.created_at,
      this.vendor_id,
      this.updated_at,
      this.description,
      this.vendor_name,
      this.varients,
      this.addons);

  factory SearchProuduct.fromJson(dynamic json){

    var vari = json['varients'] as List;

    List<SearchVaritant> varList = [];
    if(vari!=null){
      varList = vari.map((e) => SearchVaritant.fromJson(e)).toList();
    }

    var addons = json['addons'] as List;
    List<AddOnsL> _tags1 = [];
    if(addons!=null){
      _tags1 = addons.map((tagJson) => AddOnsL.fromJson(tagJson)).toList();
    }

    return SearchProuduct(json['product_id'], json['subcat_id'], json['product_name'], json['product_image'], json['created_at'], json['vendor_id'], json['updated_at'], json['description'], json['vendor_name'],varList,_tags1);
  }
}

class SearchVaritant{

  dynamic variant_id;
  dynamic product_id;
  dynamic quantity;
  dynamic unit;
  dynamic strick_price;
  dynamic price;
  dynamic vendor_id;
  dynamic subcat_id;
  dynamic product_name;
  dynamic product_image;
  dynamic created_at;
  dynamic updated_at;
  dynamic description;
  dynamic addOnQty;
  dynamic isSelected;

  SearchVaritant(
      this.variant_id,
      this.product_id,
      this.quantity,
      this.unit,
      this.strick_price,
      this.price,
      this.vendor_id,
      this.subcat_id,
      this.product_name,
      this.product_image,
      this.created_at,
      this.updated_at,
      this.description,
      this.addOnQty,
      this.isSelected);

  factory SearchVaritant.fromJson(dynamic json){
    return SearchVaritant(json['variant_id'], json['product_id'], json['quantity'], json['unit'], json['strick_price'], json['price'], json['vendor_id'], json['subcat_id'], json['product_name'], json['product_image'], json['created_at'], json['updated_at'], json['description'],0,false);
  }

  @override
  String toString() {
    return 'SearchVaritant{variant_id: $variant_id, product_id: $product_id, quantity: $quantity, unit: $unit, strick_price: $strick_price, price: $price, vendor_id: $vendor_id, subcat_id: $subcat_id, product_name: $product_name, product_image: $product_image, created_at: $created_at, updated_at: $updated_at, description: $description}';
  }
}

class AddOnsL{
  dynamic addon_id;
  dynamic addon_name;
  dynamic addon_price;
  dynamic product_id;
  dynamic vendor_id;
  dynamic isAdd;

  AddOnsL(this.addon_id, this.addon_name, this.addon_price, this.product_id,
      this.vendor_id,this.isAdd);

  factory AddOnsL.fromJson(dynamic json){
    return AddOnsL(json['addon_id'], json['addon_name'], json['addon_price'], json['product_id'], json['vendor_id'],false);
  }
}
