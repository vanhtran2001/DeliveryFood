import 'package:untitled/models/product_model.dart';

class CartModel{
  String? id;
  ProductModel? productModel;
  int? quantity;
  CartModel({
    required this.id,
    required this.productModel,
    required this.quantity,
  });
  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
        id: json['id'],
        productModel: ProductModel.fromJson(json['productModel']),
        quantity: json['quantity']);
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productModel': productModel!.toJson(),
      'quantity': quantity,
    };
  }
}