

class PopularItem{
  dynamic variant_id;
  dynamic deal_price;
  dynamic product_id;
  dynamic product_name;
  dynamic product_image;
  dynamic description;
  List<PopularItemListd> variant;
  List<AddOnList> addons;

  PopularItem(
      this.variant_id,
      this.deal_price,
      this.product_id,
      this.product_name,
      this.product_image,
      this.description,
      this.variant,
      this.addons);

  factory PopularItem.fromJson(dynamic json){
    var tagObjsJson = json['variant'] as List;
    List<PopularItemListd> _tags = [];
    if(tagObjsJson!=null){
      _tags = tagObjsJson.map((tagJson) => PopularItemListd.fromJson(tagJson)).toList();
    }
    var addons = json['addons'] as List;
    List<AddOnList> _tags1 = [];
    if(addons!=null){
      _tags1 = addons.map((tagJson) => AddOnList.fromJson(tagJson)).toList();
    }
    return PopularItem(json['variant_id'], json['deal_price'], json['product_id'], json['product_name'], json['product_image'], json['description'], _tags, _tags1);
  }
}

class PopularItemListd{

  dynamic variant_id;
  dynamic product_id;
  dynamic quantity;
  dynamic unit;
  dynamic strick_price;
  dynamic price;
  dynamic vendor_id;
  dynamic addOnQty;
  dynamic isFaviourite;
  dynamic isSelected;

  PopularItemListd(this.variant_id, this.product_id, this.quantity, this.unit,
      this.strick_price, this.price, this.vendor_id,this.addOnQty,this.isFaviourite,this.isSelected);

  factory PopularItemListd.fromJson(dynamic json){
    return PopularItemListd(json['variant_id'], json['product_id'], json['quantity'], json['unit'], json['strick_price'], json['price'], json['vendor_id'],0,0,false);
  }


  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PopularItemListd &&
          runtimeType == other.runtimeType &&
          variant_id == other.variant_id;

  @override
  int get hashCode => variant_id.hashCode;

  @override
  String toString() {
    return 'PopularItemList{variant_id: $variant_id, product_id: $product_id, quantity: $quantity, unit: $unit, strick_price: $strick_price, price: $price, vendor_id: $vendor_id}';
  }
}

class AddOnList{

  dynamic addon_id;
  dynamic addon_name;
  dynamic addon_price;
  dynamic product_id;
  dynamic vendor_id;
  dynamic isAdd;

  AddOnList(this.addon_id, this.addon_name, this.addon_price, this.product_id,
      this.vendor_id,this.isAdd);

  factory AddOnList.fromJson(dynamic json){
    return AddOnList(json['addon_id'], json['addon_name'], json['addon_price'], json['product_id'], json['vendor_id'],false);
  }
}