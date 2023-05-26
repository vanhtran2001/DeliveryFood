import 'package:untitled/models/product_model.dart';

class UserModel {
  String id, name, phoneNum, role;
  List<AddressModel> address;
  List<ProductModel> favProduct;
  UserModel({
    required this.id,
    required this.name,
    required this.phoneNum,
    required this.address,
    required this.favProduct,
    required this.role,
  });
  // we will create tojson and from json as well
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        id: json['id'],
        name: json['name'],
        phoneNum: json['phoneNum'],
        role: json['role'],
        address: json['address'] != []
            ? List<AddressModel>.from(
            json['address'].map((x) => AddressModel.fromJson(x)))
            : [],
        favProduct: json['favProduct'] != []
            ? List<ProductModel>.from(
            json['favProduct'].map((x) => ProductModel.fromJson(x)))
            : []);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phoneNum': phoneNum,
      'address': List<dynamic>.from(address.map((e) => e.toJson())),
      'favProduct': List<dynamic>.from(favProduct.map((e) => e.toJson())),
      'role': role
    };
  }
}
// first, lets change a bit in our user model, we have to add capablity to add multiple address,
// also we will add a list of products, we will add the products which are marked as favourite

class AddressModel {
  String address, area, latitude, longitude;
  AddressModel(
      {required this.address,
        required this.area,
        required this.latitude,
        required this.longitude});
  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
        address: json['address'],
        area: json['area'],
        latitude: json['latitude'],
        longitude: json['longitude']);
  }

  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'area': area,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}