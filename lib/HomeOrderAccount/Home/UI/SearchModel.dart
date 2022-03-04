import 'package:user/bean/productlistvarient.dart';

class SearchModel {
  List<Data> data;

  SearchModel({this.data});

  SearchModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  var uiType;
  var vendorName;
  var vendorId;
  var vendorCategoryId;
  var vendorLoc;
  var vendorLogo;
  var vendorPhone;
  var onlineStatus;
  var deliveryRange;
  var about;
  var distance;
  var categoryName;
  var type;
  var productId;
  var productName;
  var productImage;
  List<VarientList> varient;

  Data(
      {this.uiType,
      this.vendorName,
      this.vendorId,
      this.vendorCategoryId,
      this.vendorLoc,
      this.vendorLogo,
      this.vendorPhone,
      this.onlineStatus,
      this.deliveryRange,
      this.about,
      this.distance,
      this.categoryName,
      this.type,
      this.productId,
      this.productName,
      this.productImage,
      this.varient});

  Data.fromJson(Map<String, dynamic> json) {
    uiType = json['ui_type'];
    vendorName = json['vendor_name'];
    vendorId = json['vendor_id'];
    vendorCategoryId = json['vendor_category_id'];
    vendorLoc = json['vendor_loc'];
    vendorLogo = json['vendor_logo'];
    vendorPhone = json['vendor_phone'];
    onlineStatus = json['online_status'];
    deliveryRange = json['delivery_range'];
    about = json['about'];
    distance = json['distance'];
    categoryName = json['category_name'];
    type = json['type'];
    productId = json['product_id'];
    productName = json['product_name'];
    productImage = json['product_image'];
    if (json['varient'] != null) {
      varient = <VarientList>[];
      json['varient'].forEach((v) {
        varient.add(new VarientList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ui_type'] = this.uiType;
    data['vendor_name'] = this.vendorName;
    data['vendor_id'] = this.vendorId;
    data['vendor_category_id'] = this.vendorCategoryId;
    data['vendor_loc'] = this.vendorLoc;
    data['vendor_logo'] = this.vendorLogo;
    data['vendor_phone'] = this.vendorPhone;
    data['online_status'] = this.onlineStatus;
    data['delivery_range'] = this.deliveryRange;
    data['about'] = this.about;
    data['distance'] = this.distance;
    data['category_name'] = this.categoryName;
    data['type'] = this.type;
    data['product_id'] = this.productId;
    data['product_name'] = this.productName;
    data['product_image'] = this.productImage;
    if (this.varient != null) {
      data['varient'] = this.varient.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
/*
class Varient {
  var varientId;
  var productId;
  var quantity;
  var unit;
  var strickPrice;
  var price;
  var description;
  var varientImage;
  var vendorId;
  var stock;

  Varient(
      {this.varientId,
      this.productId,
      this.quantity,
      this.unit,
      this.strickPrice,
      this.price,
      this.description,
      this.varientImage,
      this.vendorId,
      this.stock});

  Varient.fromJson(Map<String, dynamic> json) {
    varientId = json['varient_id'];
    productId = json['product_id'];
    quantity = json['quantity'];
    unit = json['unit'];
    strickPrice = json['strick_price'];
    price = json['price'];
    description = json['description'];
    varientImage = json['varient_image'];
    vendorId = json['vendor_id'];
    stock = json['stock'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['varient_id'] = this.varientId;
    data['product_id'] = this.productId;
    data['quantity'] = this.quantity;
    data['unit'] = this.unit;
    data['strick_price'] = this.strickPrice;
    data['price'] = this.price;
    data['description'] = this.description;
    data['varient_image'] = this.varientImage;
    data['vendor_id'] = this.vendorId;
    data['stock'] = this.stock;
    return data;
  }
}*/
