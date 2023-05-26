import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/helper/utils.dart';
import 'package:untitled/models/product_model.dart';
import 'package:untitled/providers/cart_provider.dart';
import 'package:untitled/screens/select_address.dart';

import '../helper/colors.dart';
import '../helper/const.dart';
import '../models/cart_model.dart';
import 'login_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    List<CartModel> cartItems = [];
    cartItems.addAll(
        Provider.of<CartProvider>(context, listen: false).cartItem.values);
    return Scaffold(
      bottomSheet: cartItems.isEmpty
          ? Container(
        height: 0,
      )
          : Container(
        // padding: EdgeInsets.all(10),
          width: MediaQuery.of(context).size.width,
          child: IntrinsicHeight(
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      getBoldText(
                          'Tổng cộng:', MyColors.primaryColor, 17),
                      getBoldText(
                          '${Provider.of<CartProvider>(context, listen: false).getTotalPrice()} ₫',
                          Colors.black,
                          17)
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                currentUser == null
                    ? GestureDetector(
                  onTap: () {
                    pushNavigate(context, LoginScreen());
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        color: MyColors.primaryColor,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10))),
                    width: MediaQuery.of(context).size.width,
                    child: getBoldText('Đăng nhập', Colors.white, 15),
                  ),
                )
                    : GestureDetector(
                  onTap: () {
                    pushNavigate(context, SelectAddress());
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        color: MyColors.primaryColor,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10))),
                    width: MediaQuery.of(context).size.width,
                    child:
                    getBoldText('Thanh toán', Colors.white, 15),
                  ),
                )
              ],
            ),
          )),
      appBar: getOtherScreenAppBar('Giỏ hàng', context),
      body: cartItems.isEmpty
          ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.no_meals,
                size: 100,
              ),
              getBoldText('Giỏ hàng trống', Colors.black, 18),
            ],
          ))
          : ListView.builder(
        itemCount: cartItems.length,
        itemBuilder: (BuildContext context, int index) {
          return getCartItem(cartItems[index].productModel!);
        },
      ),
    );
  }
  Widget getCartItem(ProductModel productModel) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Row(
                children: [
                  Container(
                      width: MediaQuery.of(context).size.width / 5,
                      height: MediaQuery.of(context).size.width / 5,
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(productModel.imgUrl),
                      )),
                  SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        getBoldText(productModel.name, Colors.black, 15),
                        getNormalText(
                            '${productModel.price} ₫', Colors.black, 15)
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Spacer(),
            Provider.of<CartProvider>(context).cartItemQuantity(productModel.name) ==
                0
                ? GestureDetector(
              onTap: () {
                Provider.of<CartProvider>(context, listen: false)
                    .addToCart(
                    CartModel(
                        id: productModel.name,
                        productModel: productModel,
                        quantity: 1),
                    true);
              },
              child: Container(
                padding:
                EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                    color: MyColors.primaryColor,
                    borderRadius: BorderRadius.circular(5)),
                child: getNormalText('ADD +', Colors.white, 16),
              ),
            )
                : Container(
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Provider.of<CartProvider>(context, listen: false)
                          .addToCart(
                          CartModel(
                              id: productModel.name,
                              productModel: productModel,
                              quantity: 1),
                          false);
                      if (Provider.of<CartProvider>(context,
                          listen: false)
                          .cartItemQuantity(productModel.name) ==
                          0) {
                        Provider.of<CartProvider>(context, listen: false)
                            .removeFromCart(productModel.name);
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: MyColors.primaryColor.withOpacity(0.2)),
                      child: Icon(
                        Icons.remove,
                        color: MyColors.primaryColor,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: getBoldText(
                        Provider.of<CartProvider>(context)
                            .cartItemQuantity(productModel.name)
                            .toString(),
                        Colors.black,
                        15),
                  ),
                  GestureDetector(
                    onTap: () {
                      Provider.of<CartProvider>(context, listen: false)
                          .addToCart(
                          CartModel(
                              id: productModel.name,
                              productModel: productModel,
                              quantity: 1),
                          true);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: MyColors.primaryColor.withOpacity(0.2)),
                      child: Icon(
                        Icons.add,
                        color: MyColors.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
