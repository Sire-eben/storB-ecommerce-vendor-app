class Address {
  String? name;
  String? phoneNumber;
  String? flatNumber;
  String? city;
  String? state;
  String? fullAddress;
  double? lat;
  double? long;

  Address({
    this.fullAddress,
    this.city,
    this.flatNumber,
    this.lat,
    this.long,
    this.name,
    this.phoneNumber,
    this.state,
  });

  Address.fromJson(Map<String, dynamic> json){
    name = json['name'];
    phoneNumber = json['phoneNumber'];
    flatNumber = json['flatNumber'];
    city = json['city'];
    state = json['state'];
    fullAddress = json['fullAddress'];
    lat = json['lat'];
    long = json['long'];
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['phoneNumber'] = phoneNumber;
    data['fullAddress'] = fullAddress;
    data['city'] = city;
    data['state'] = state;
    data['fullAddress'] = fullAddress;
    data['lat'] = lat;
    data['long'] = long;

    return data;
  }
}
