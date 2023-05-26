import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled/admin/screens/add_product.dart';
import 'package:untitled/admin/screens/edit_product.dart';
import 'package:untitled/helper/colors.dart';
import 'package:untitled/helper/utils.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final Stream<QuerySnapshot> _productStream = FirebaseFirestore.instance.collection('products').snapshots();
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
          floatingActionButton: FloatingActionButton(
            onPressed: (){
              pushNavigate(context, AddProduct());
            },
            child: Icon(Icons.add),
          ),
          appBar: getOtherScreenAppBar('Sản phẩm', context),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ListView(
        children: snapshot.data!.docs.map((DocumentSnapshot document) {
          Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
          return Card(
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5)
                  ),
                  width: MediaQuery.of(context).size.width / 5,
                  height: MediaQuery.of(context).size.width / 5,
                  child: Image.network(data['imgUrl']),
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    getNormalText(data['category'], Colors.grey, 12),
                    getBoldText(data['name'], MyColors.primaryColor, 16),
                    getNormalText('${data['price']} ₫', Colors.black, 14)
                  ],
                ),
                Spacer(),
                IconButton(onPressed: () {
                  pushNavigate(context, EditProduct(data: data, id: document.id));
                }, icon: Icon(Icons.edit))
              ],
            ),
          );
        }).toList(),
        ),
        ),
        );

      },
    );
  }
}
