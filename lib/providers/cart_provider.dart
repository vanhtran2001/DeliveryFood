import 'package:flutter/cupertino.dart';
import 'package:untitled/models/cart_model.dart';

class CartProvider with ChangeNotifier{
  Map<String, CartModel> _cartItems = {};
  Map<String, CartModel> get cartItem => _cartItems;

  void addToCart(CartModel cartItem, bool isIncrease){
    if(_cartItems.containsKey(cartItem.productModel!.name)) {
      _cartItems.update(cartItem.productModel!.name, (value) => CartModel(
          id: value.id,
          productModel: value.productModel,
          quantity: isIncrease? value.quantity!+1: value.quantity!-1));
    } else {
      _cartItems.putIfAbsent(cartItem.productModel!.name, () => cartItem);
      print('added');
    }
    notifyListeners();
  }

  int totalCartItem(){
    return _cartItems.length;
  }

  int cartItemQuantity(String name){
    return _cartItems.containsKey(name) ? _cartItems[name]!.quantity! : 0;
  }

  removeFromCart(String name){
    _cartItems.remove(name);
    notifyListeners();
  }

  void clearCart(){
    _cartItems.clear();
    notifyListeners();
  }

  int getTotalPrice(){
    int total = 0;
    _cartItems.forEach((key, value) {
      total += int.parse(value.productModel!.price) * value.quantity!;
    });
    return total;
  }
}