import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/screens/cart_screen.dart';
import 'package:untitled/helper/utils.dart';
import 'package:untitled/models/product_model.dart';

import '../helper/colors.dart';
import '../models/cart_model.dart';
import '../providers/cart_provider.dart';

class ProductDetail extends StatefulWidget {

  ProductModel productModel;

  ProductDetail({Key? key, required this.productModel}) : super(key: key);

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  List<ProductModel> products = [
    ProductModel(
        name: 'Spaghetti',
        description: 'Vị ngọt thơm từ bạch tuộc baby kết hợp với mì Ý dai dai thơm mùi tỏi tạo nên món ăn ngon khó tả mang đậm hương vị Ý',
        price: '39000',
        shortDescription: 'Spaghetti là một loại mì pasta có sợi tròn nhỏ, được làm từ bột mì loại Semolina và nước',
        imgUrl: 'assets/images/monau1.jpg',
        category: 'Món Âu',
        isAvailable: true
    ),
    ProductModel(
        name: 'Spaghetti',
        description: 'Vị ngọt thơm từ bạch tuộc baby kết hợp với mì Ý dai dai thơm mùi tỏi tạo nên món ăn ngon khó tả mang đậm hương vị Ý',
        price: '39000',
        shortDescription: 'Spaghetti là một loại mì pasta có sợi tròn nhỏ, được làm từ bột mì loại Semolina và nước',
        imgUrl: 'assets/images/monau1.jpg',
        category: 'Món Âu',
        isAvailable: true
    ),
    ProductModel(
        name: 'Spaghetti',
        description: 'Vị ngọt thơm từ bạch tuộc baby kết hợp với mì Ý dai dai thơm mùi tỏi tạo nên món ăn ngon khó tả mang đậm hương vị Ý',
        price: '39000',
        shortDescription: 'Spaghetti là một loại mì pasta có sợi tròn nhỏ, được làm từ bột mì loại Semolina và nước',
        imgUrl: 'assets/images/monau1.jpg',
        category: 'Món Âu',
        isAvailable: true
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: GestureDetector(
        onTap: () {
          pushNavigate(context, CartScreen());
        },
        child: Container(
          alignment: Alignment.center,
          height: 50,
          width: getTotalWidth(context),
          color: Colors.blue,
          child: getBoldText('Xem giỏ hàng', Colors.white, 16)
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            flexibleSpace: FlexibleSpaceBar(
              title: getBoldText(widget.productModel.name, Colors.white, 18),
              background: Image.network(
                widget.productModel.imgUrl,
                fit: BoxFit.fill,
              ),
              centerTitle: false,
            ),
            pinned: true,
            actions: [
              IconButton(onPressed: (){}, icon: Icon(Icons.favorite_border))
            ],
            expandedHeight: getTotalHeight(context) / 3,
          ),
          SliverList(delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Provider.of<CartProvider>(context).cartItemQuantity(widget.productModel.name) == 0?
                            GestureDetector(
                              onTap: () {
                                Provider.of<CartProvider>(context, listen: false).addToCart(CartModel(
                                    id: widget.productModel.name,
                                    productModel: widget.productModel,
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
                                            id: widget.productModel.name,
                                            productModel: widget.productModel,
                                            quantity: 1),
                                            false);
                                        if(Provider.of<CartProvider>(context, listen: false).cartItemQuantity(widget.productModel.name) == 0){
                                          Provider.of<CartProvider>(context, listen: false).removeFromCart(widget.productModel.name);
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
                                          .cartItemQuantity(widget.productModel.name)
                                          .toString(),
                                          Colors.black,
                                          15),),
                                    GestureDetector(
                                      onTap: () {
                                        Provider.of<CartProvider>(context, listen: false).addToCart(CartModel(
                                            id: widget.productModel.name,
                                            productModel: widget.productModel,
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
                        ),
                      ),
                      Divider(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            getBoldText(widget.productModel.price + ' ₫', Colors.black, 18),
                            getNormalText('1 Phần', Colors.black, 18)
                          ],
                        ),
                      ),
                      Divider(),
                      getNormalText(widget.productModel.description, Colors.black, 16),
                      SizedBox(
                        height: 10,
                      ),
                      /*getBoldText('Bạn cũng có thể thích', Colors.black, 18),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: products.length,
                          itemBuilder: (BuildContext context, int index){
                            return getProductCard(
                              products[index]
                            );
                          })*/
                    ],
                  ),
                ),
          ]))
        ],
      ),
    );
  }

  getProductCard(ProductModel productModel){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Row(
          children: [
            Flexible(
              flex: 1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.network(productModel.imgUrl),
            )
            ),
            SizedBox(
              width: 10,
            ),
            Flexible(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  getNormalText(productModel.name, Colors.black, 16),
                  getNormalText('${productModel.price} ₫', Colors.grey, 14),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
