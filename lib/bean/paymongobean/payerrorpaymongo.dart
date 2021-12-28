class PayErrorPaymongo {
  List<PayErrors> errors;

  PayErrorPaymongo({this.errors});

  PayErrorPaymongo.fromJson(Map<String, dynamic> json) {
    if (json['errors'] != null) {
      errors = new List<PayErrors>();
      json['errors'].forEach((v) {
        errors.add(new PayErrors.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.errors != null) {
      data['errors'] = this.errors.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PayErrors {
  dynamic code;
  dynamic detail;
  PaySource source;

  PayErrors({this.code, this.detail, this.source});

  PayErrors.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    detail = json['detail'];
    source =
    json['source'] != null ? new PaySource.fromJson(json['source']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['detail'] = this.detail;
    if (this.source != null) {
      data['source'] = this.source.toJson();
    }
    return data;
  }
}

class PaySource {
  dynamic pointer;
  dynamic attribute;

  PaySource({this.pointer, this.attribute});

  PaySource.fromJson(Map<String, dynamic> json) {
    pointer = json['pointer'];
    attribute = json['attribute'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pointer'] = this.pointer;
    data['attribute'] = this.attribute;
    return data;
  }
}