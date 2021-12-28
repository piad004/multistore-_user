import 'package:user/bean/productlistvarient.dart';
import 'package:user/bean/subcategorylist.dart';

class SearchProduct {
  dynamic status;
  dynamic message;
  List<SearchList> stores;
  List<CategoryList> category;
  List<SubCategoryList> subcat;
  List<ProductVarient> products;


  SearchProduct(this.status, this.message, this.stores, this.category,
      this.subcat, this.products);

  factory SearchProduct.fromJson(dynamic json){
    var tagObjsJsonStore = json['stores'] as List;
    var tagObjsJsonCategory = json['category'] as List;
    var tagObjsJsonSub = json['subcat'] as List;
    var tagObjsJsonProd = json['products'] as List;

    List<SearchList> _tags = tagObjsJsonStore.map((tagJson) => SearchList.fromJson(tagJson)).toList();
    if(_tags==null || _tags.length == 0){
      _tags = [];
    }
    List<CategoryList> _tags2 = tagObjsJsonCategory.map((tagJson) => CategoryList.fromJson(tagJson)).toList();
    if(_tags2==null || _tags2.length == 0){
      _tags2 = [];
    }
    List<SubCategoryList> _tags3 = tagObjsJsonSub.map((tagJson) => SubCategoryList.fromJson(tagJson)).toList();
    if(_tags3==null || _tags3.length == 0){
      _tags3 = [];
    }
    List<ProductVarient> _tags4 = tagObjsJsonProd.map((tagJson) => ProductVarient.fromJson(tagJson)).toList();
    if(_tags4==null || _tags4.length == 0){
      _tags4 = [];
    }

    return SearchProduct(json['status'], json['message'], _tags, _tags2, _tags3, _tags4);

  }

  @override
  String toString() {
    return 'SearchProduct{status: $status, message: $message, stores: $stores, category: $category, subcat: $subcat, products: $products}';
  }
}

class SearchList {
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
  dynamic distance;
  dynamic type;

  SearchList(
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
      this.distance,
      this.type);

  factory SearchList.fromJson(dynamic json){
    return SearchList(json['vendor_id'], json['vendor_name'], json['owner'], json['cityadmin_id'], json['vendor_email'], json['vendor_phone'], json['vendor_logo'], json['vendor_loc'], json['lat'], json['lng'], json['opening_time'], json['closing_time'], json['vendor_pass'], json['created_at'], json['updated_at'], json['vendor_category_id'], json['comission'], json['distance'],'store');
  }

  @override
  String toString() {
    return 'SearchList{vendor_id: $vendor_id, vendor_name: $vendor_name, owner: $owner, cityadmin_id: $cityadmin_id, vendor_email: $vendor_email, vendor_phone: $vendor_phone, vendor_logo: $vendor_logo, vendor_loc: $vendor_loc, lat: $lat, lng: $lng, opening_time: $opening_time, closing_time: $closing_time, vendor_pass: $vendor_pass, created_at: $created_at, updated_at: $updated_at, vendor_category_id: $vendor_category_id, comission: $comission, distance: $distance, type: $type}';
  }
}


class CategoryList{
  dynamic category_id;
  dynamic cityadmin_id;
  dynamic category_name;
  dynamic category_image;
  dynamic home;
  dynamic created_at;
  dynamic updated_at;
  dynamic vendor_id;
  dynamic subcat_id;
  dynamic subcat_name;
  dynamic subcat_image;
  dynamic type;
  dynamic vendor_name;
  dynamic distance;

  CategoryList(
      this.category_id,
      this.cityadmin_id,
      this.category_name,
      this.category_image,
      this.home,
      this.created_at,
      this.updated_at,
      this.vendor_id,
      this.subcat_id,
      this.subcat_name,
      this.subcat_image,
      this.type,
      this.vendor_name,
      this.distance);

  factory CategoryList.fromJson(dynamic json){
    return CategoryList(json['category_id'], json['cityadmin_id'], json['category_name'], json['category_image'], json['home'], json['created_at'], json['updated_at'], json['vendor_id'], json['subcat_id'], json['subcat_name'], json['subcat_image'],'Category',json['vendor_name'],json['distance']);
  }

  @override
  String toString() {
    return 'CategoryList{category_id: $category_id, cityadmin_id: $cityadmin_id, category_name: $category_name, category_image: $category_image, home: $home, created_at: $created_at, updated_at: $updated_at, vendor_id: $vendor_id, subcat_id: $subcat_id, subcat_name: $subcat_name, subcat_image: $subcat_image, type: $type, vendor_name: $vendor_name, distance: $distance}';
  }
}

class ProductVarient{
  dynamic product_id;
  dynamic subcat_id;
  dynamic product_name;
  dynamic products_image;
  dynamic created_at;
  dynamic updated_at;
  dynamic vendor_id;
  dynamic type;
  dynamic vendor_name;
  List<VarientList> data;
  dynamic add_qnty;


  ProductVarient(
      this.product_id,
      this.subcat_id,
      this.product_name,
      this.products_image,
      this.created_at,
      this.updated_at,
      this.vendor_id,
      this.type,
      this.vendor_name,
      this.data,
      this.add_qnty);

  factory ProductVarient.fromJson(dynamic json){
    var tagObjsJsond = json['varients'] as List;
    if(tagObjsJsond.length>0){
      List<VarientList> _tags = tagObjsJsond.map((tagJson) => VarientList.fromJson(tagJson)).toList();
      return ProductVarient(json['product_id'], json['subcat_id'],json['product_name'], json['products_image'], json['created_at'],json['updated_at'],json['vendor_id'],'producttype',json['vendor_name'],_tags,0);
    }else{
      return ProductVarient(json['product_id'], json['subcat_id'],json['product_name'], json['products_image'], json['created_at'],json['updated_at'],json['vendor_id'],'producttype',json['vendor_name'],[],0);
    }
  }

  @override
  String toString() {
    return 'ProductVarient{product_id: $product_id, subcat_id: $subcat_id, product_name: $product_name, products_image: $products_image, created_at: $created_at, updated_at: $updated_at, add_qnty: $add_qnty, vendor_id: $vendor_id, type: $type, data: $data}';
  }
}