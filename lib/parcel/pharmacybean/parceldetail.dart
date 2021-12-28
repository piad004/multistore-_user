
class ParcelDetailBean {

  dynamic parcelWeight;
  dynamic pickupdate;
  dynamic pickuptime;
  dynamic length;
  dynamic width;
  dynamic height;
  dynamic parcelDescription;

  ParcelDetailBean(this.parcelWeight, this.pickupdate, this.pickuptime,
      this.length, this.width, this.height, this.parcelDescription);

  @override
  String toString() {
    return 'Parcel Weight : $parcelWeight KG\nParcel Dimenssion : $length X $width X $height\nParcel Description : $parcelDescription\nPickup Date : $pickupdate\nPickup Time : $pickuptime';
  }
}