import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:untitled/helper/utils.dart';

import '../../helper/colors.dart';
import '../api/coupon_api/coupon_api.dart';
import 'add_coupon.dart';

class CouponScreen extends StatefulWidget {
  const CouponScreen({super.key});

  @override
  State<CouponScreen> createState() => _CouponScreenState();
}

class _CouponScreenState extends State<CouponScreen> {
  deleteCoupon(String id) {
    setState(() {
      isLoading = true;
    });
    CouponApi().deleteCoupon(id).then((value) {
      setState(() {
        isLoading = false;
      });
      getSnackBar('Xóa thành công', context);
    }).onError((error, stackTrace) {
      setState(() {
        isLoading = false;
      });
      getSnackBar(error.toString(), context);
    });
  }

  bool isLoading = false;
  final Stream<QuerySnapshot> _couponStream =
      FirebaseFirestore.instance.collection('coupons').snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _couponStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  pushNavigate(context, AddCoupon());
                },
                child: Icon(Icons.add),
              ),
              appBar: getOtherScreenAppBar('Mã giảm giá', context),
              body: getLoading());
        }
        return Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              pushNavigate(context, AddCoupon());
            },
            child: Icon(Icons.add),
          ),
          appBar: getOtherScreenAppBar('Mã giảm giá', context),
          body: isLoading
              ? getLoading()
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ListView(
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data()! as Map<String, dynamic>;

                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  getNormalText(
                                      DateFormat('dd MMMM yy').format(
                                          DateTime.parse(data['startDate']
                                              .toDate()
                                              .toString())),
                                      Colors.grey,
                                      12),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  getBoldText(
                                      data['name'], MyColors.primaryColor, 16),
                                  // getNormalText('₹ ${data['price']}', Colors.black, 14)
                                ],
                              ),
                              Spacer(),
                              IconButton(
                                  onPressed: () {
                                    deleteCoupon(document.id);
                                  },
                                  icon: Icon(Icons.delete))
                            ],
                          ),
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
