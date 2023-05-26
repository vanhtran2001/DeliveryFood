import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/screens/cart_screen.dart';
import 'package:untitled/helper/colors.dart';
import 'package:untitled/helper/utils.dart';
import 'package:untitled/models/cart_model.dart';
import 'package:untitled/providers/cart_provider.dart';
import 'package:untitled/screens/product_detail.dart';

import '../models/product_model.dart';

class ProductList extends StatefulWidget {

  String title;

  ProductList({Key? key, required this.title}) : super(key: key);

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  String? title;
  Stream<QuerySnapshot>? _productStream;

  @override
  void initState() {
    title = widget.title;
    super.initState();
    _productStream = FirebaseFirestore.instance
        .collection('products')
        .where('category', isEqualTo: title)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _productStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: getOtherScreenAppBar('Sản phẩm', context),
            body: getLoading(),
          );
        }
        return Scaffold(
          appBar: AppBar(
            toolbarHeight: 80,
            elevation: 0,
            title: Text(widget.title),
            actions: [
              IconButton(
                onPressed: () {
                  pushNavigate(context, CartScreen());
                }, icon: Stack(
                alignment: Alignment.topRight,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.shopping_cart),
                  ),
                  Provider.of<CartProvider>(context).totalCartItem() == 0
                      ? Container(
                    height: 0,
                  )
                      : Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50)
                    ),
                    child: getNormalText(Provider.of<CartProvider>(context).totalCartItem().toString(), MyColors.primaryColor, 12),
                  ),
                ],
              ))
            ],
            flexibleSpace: Stack(
              alignment: Alignment.bottomCenter,
              children:[ Container(
                height: 250,
                color: Colors.blue,
              ),
                Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50),
                          topRight: Radius.circular(50)
                      )
                  ),
                  height: 20,
                )
              ],
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                ProductModel product = ProductModel.fromJson(data);
                return getProductCard(product);
              }).toList(),
            ),
          ),
        );

      },
    );
  }

  Widget getProductCard(ProductModel product){
    return GestureDetector(
        onTap: () {
          pushNavigate(context, ProductDetail(productModel: product));
        },
        child: Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  width: getTotalWidth(context),
                  height: getTotalHeight(context) / 3,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10)
                    ),
                    child: Image.network(
                      product.imgUrl,
                      fit: BoxFit.fill,
                    ),)
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    getBoldText(product.name, Colors.black, 18),
                    SizedBox(
                      height: 10,
                    ),
                    getNormalText(product.shortDescription, Colors.black, 16),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        getBoldText('${product.price} ₫', Colors.black, 20),
                        Provider.of<CartProvider>(context).cartItemQuantity(product.name) == 0?
                        GestureDetector(
                          onTap: () {
                            Provider.of<CartProvider>(context, listen: false).addToCart(CartModel(
                                id: product.name,
                                productModel: product,
                                quantity: 1),
                                true);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5
                            ),
                            decoration: BoxDecoration(
                                color: MyColors.primaryColor,
                                borderRadius: BorderRadius.circular(5)
                            ),
                            child: getNormalText('Thêm vào giỏ', Colors.white, 16),
                          ),
                        ): Container(
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Provider.of<CartProvider>(context, listen: false).addToCart(CartModel(
                                      id: product.name,
                                      productModel: product,
                                      quantity: 1),
                                      false);
                                  if(Provider.of<CartProvider>(context, listen: false).cartItemQuantity(product.name) == 0){
                                    Provider.of<CartProvider>(context, listen: false).removeFromCart(product.name);
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: MyColors.primaryColor.withOpacity(0.5)
                                  ),
                                  child: Icon(Icons.remove, color: MyColors.primaryColor,),
                                ),
                              ),
                              Padding(padding: EdgeInsets.symmetric(horizontal: 5),
                                child: getBoldText(Provider.of<CartProvider>(context)
                                    .cartItemQuantity(product.name)
                                    .toString(),
                                    Colors.black,
                                    15),),
                              GestureDetector(
                                onTap: () {
                                  Provider.of<CartProvider>(context, listen: false).addToCart(CartModel(
                                      id: product.name,
                                      productModel: product,
                                      quantity: 1),
                                      true);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: MyColors.primaryColor.withOpacity(0.5)
                                  ),
                                  child: Icon(Icons.add, color: MyColors.primaryColor,),
                                ),
                              ),
                            ],
                          )
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        )
    );
  }
}
