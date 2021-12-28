
class CategoryResturant {
  dynamic resturant_cat_id;
  dynamic cat_name;
  dynamic product_id;
  dynamic product_name;
  dynamic product_image;
  dynamic description;
  List<ResturantVarient> variant;
  List<AddOns> addons;
  CategoryResturant(this.resturant_cat_id, this.cat_name, this.product_id,
      this.product_name, this.product_image, this.description, this.variant, this.addons);
  factory CategoryResturant.fromJson(dynamic json){

    var tagObjsJson = json['variant'] as List;
    List<ResturantVarient> _tags = [];
    if(tagObjsJson!=null){
      _tags = tagObjsJson.map((tagJson) => ResturantVarient.fromJson(tagJson)).toList();
    }
    var addons = json['addons'] as List;
    List<AddOns> _tags1 = [];
    if(addons!=null){
      _tags1 = addons.map((tagJson) => AddOns.fromJson(tagJson)).toList();
    }
    return CategoryResturant(json['resturant_cat_id'], json['cat_name'], json['product_id'], json['product_name'], json['product_image'], json['description'], _tags, _tags1);
  }

  @override
  String toString() {
    return '{resturant_cat_id: $resturant_cat_id, cat_name: $cat_name, product_id: $product_id, product_name: $product_name, product_image: $product_image, description: $description, variant: $variant, addons: $addons}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryResturant &&
          runtimeType == other.runtimeType &&
          resturant_cat_id == other.resturant_cat_id &&
          product_id == other.product_id;

  @override
  int get hashCode => resturant_cat_id.hashCode ^ product_id.hashCode;

// @override
  // bool operator ==(Object other) =>
  //     identical(this, other) ||
  //     other is CategoryResturant &&
  //         runtimeType == other.runtimeType &&
  //         (resturant_cat_id == other.resturant_cat_id && product_id == other.product_id);
  //
  // @override
  // int get hashCode => resturant_cat_id.hashCode;


}

class CategoryResturantR {
  dynamic resturant_cat_id;
  dynamic cat_name;
  dynamic product_id;
  dynamic product_name;
  dynamic product_image;
  dynamic description;
  List<ResturantVarient> variant;
  List<AddOns> addons;
  CategoryResturantR(this.resturant_cat_id, this.cat_name, this.product_id,
      this.product_name, this.product_image, this.description, this.variant, this.addons);
  factory CategoryResturantR.fromJson(dynamic json){

    var tagObjsJson = json['variant'] as List;
    List<ResturantVarient> _tags = [];
    if(tagObjsJson!=null){
      _tags = tagObjsJson.map((tagJson) => ResturantVarient.fromJson(tagJson)).toList();
    }
    var addons = json['addons'] as List;
    List<AddOns> _tags1 = [];
    if(addons!=null){
      _tags1 = addons.map((tagJson) => AddOns.fromJson(tagJson)).toList();
    }
    return CategoryResturantR(json['resturant_cat_id'], json['cat_name'], json['product_id'], json['product_name'], json['product_image'], json['description'], _tags, _tags1);
  }

  @override
  String toString() {
    return '{resturant_cat_id: $resturant_cat_id, cat_name: $cat_name, product_id: $product_id, product_name: $product_name, product_image: $product_image, description: $description, variant: $variant, addons: $addons}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryResturantR &&
          runtimeType == other.runtimeType &&
          resturant_cat_id == other.resturant_cat_id;

  @override
  int get hashCode => resturant_cat_id.hashCode;

// @override
// bool operator ==(Object other) =>
//     identical(this, other) ||
//     other is CategoryResturant &&
//         runtimeType == other.runtimeType &&
//         (resturant_cat_id == other.resturant_cat_id && product_id == other.product_id);
//
// @override
// int get hashCode => resturant_cat_id.hashCode;


}

class ResturantVarient{
  dynamic variant_id;
  dynamic product_id;
  dynamic quantity;
  dynamic unit;
  dynamic strick_price;
  dynamic price;
  dynamic vendor_id;
  dynamic addOnQty;
  dynamic isSelected;
  dynamic isFaviourite;


  ResturantVarient(this.variant_id, this.product_id, this.quantity, this.unit,
      this.strick_price, this.price, this.vendor_id,this.addOnQty,this.isFaviourite,this.isSelected);

  factory ResturantVarient.fromJson(dynamic json){
    return ResturantVarient(json['variant_id'], json['product_id'], json['quantity'], json['unit'], json['strick_price'], json['price'], json['vendor_id'],0,0,false);
  }

  @override
  String toString() {
    return '{variant_id: $variant_id, product_id: $product_id, quantity: $quantity, unit: $unit, strick_price: $strick_price, price: $price, vendor_id: $vendor_id, addOnQty: $addOnQty, isSelected: $isSelected, isFaviourite: $isFaviourite}';
  }
}

class AddOns{
  dynamic addon_id;
  dynamic addon_name;
  dynamic addon_price;
  dynamic product_id;
  dynamic vendor_id;
  dynamic isAdd;

  AddOns(this.addon_id, this.addon_name, this.addon_price, this.product_id,
      this.vendor_id,this.isAdd);

  factory AddOns.fromJson(dynamic json){
    return AddOns(json['addon_id'], json['addon_name'], json['addon_price'], json['product_id'], json['vendor_id'],false);
  }

  @override
  String toString() {
    return '{addon_id: $addon_id, addon_name: $addon_name, addon_price: $addon_price, product_id: $product_id, vendor_id: $vendor_id, isAdd: $isAdd}';
  }
}