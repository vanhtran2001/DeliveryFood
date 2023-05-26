import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:untitled/models/product_model.dart';

class ProductApi{
  CollectionReference users = FirebaseFirestore.instance.collection('products');

  Future<void> addProduct(ProductModel productModel) {
    return users
        .add(productModel.toJson())
        .then((value) => print("Product Added"))
        .catchError((error) {
          throw error;
    });
  }

  Future<void> updateProduct(String id, ProductModel productModel) {
    return users
        .doc(id)
        .set(productModel.toJson())
        .then((value) => print("Product Updated"))
        .catchError((error) {
          throw error;
    });
  }
}