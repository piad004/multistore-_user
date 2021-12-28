

class AddonList{
  dynamic addonid;

  AddonList(this.addonid);

  factory AddonList.fromJson(dynamic json){
    return AddonList(json['addonid']);
  }

  @override
  String toString() {
    return '{addonid: $addonid}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AddonList &&
          runtimeType == other.runtimeType &&
          addonid == other.addonid;

  @override
  int get hashCode => addonid.hashCode;
}