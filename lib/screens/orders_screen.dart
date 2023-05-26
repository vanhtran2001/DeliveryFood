import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../helper/colors.dart';
import '../helper/const.dart';
import '../helper/utils.dart';
import '../models/order_model.dart';
import 'order_details.dart';

class UserOrderScreen extends StatefulWidget {
  const UserOrderScreen({super.key});

  @override
  State<UserOrderScreen> createState() => _UserOrderScreenState();
}

class _UserOrderScreenState extends State<UserOrderScreen> {
  String selectedTab = 'Đang giao';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _orderStream = FirebaseFirestore.instance
        .collection('orders')
        .where('userId', isEqualTo: currentUser!.id)
        .where('status', isEqualTo: selectedTab)
        .snapshots();
    return StreamBuilder<QuerySnapshot>(
      stream: _orderStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: getOtherScreenAppBar('Đơn hàng', context),
            body: Center(
              child: getLoading(),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            toolbarHeight: 130,
            elevation: 0,
            title: Text('Đơn hàng'),
            flexibleSpace: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  height: 250,
                  color: MyColors.primaryColor,
                ),
                IntrinsicHeight(
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(50),
                                topRight: Radius.circular(50))),
                        height: 20,
                      ),
                      Container(
                        decoration: BoxDecoration(color: Colors.white),
                        height: 30,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedTab = 'Đang giao';
                                  });
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  width:
                                      MediaQuery.of(context).size.width / 3.5,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: selectedTab == 'Đang giao'
                                          ? MyColors.primaryColor
                                          : Colors.white),
                                  child: Padding(
                                    padding: EdgeInsets.all(5),
                                    child: getNormalText(
                                        'Đang giao',
                                        selectedTab == 'Đang giao'
                                            ? Colors.white
                                            : Colors.black,
                                        14),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedTab = 'Đã hủy';
                                  });
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  width:
                                      MediaQuery.of(context).size.width / 3.5,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: selectedTab == 'Đã hủy'
                                          ? MyColors.primaryColor
                                          : Colors.white),
                                  child: Padding(
                                    padding: EdgeInsets.all(5),
                                    child: getNormalText(
                                        'Đã hủy',
                                        selectedTab == 'Đã hủy'
                                            ? Colors.white
                                            : Colors.black,
                                        14),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedTab = 'Đã hoàn thành';
                                  });
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  width:
                                      MediaQuery.of(context).size.width / 3.5,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: selectedTab == 'Đã hoàn thành'
                                          ? MyColors.primaryColor
                                          : Colors.white),
                                  child: Padding(
                                    padding: EdgeInsets.all(5),
                                    child: getNormalText(
                                        'Đã hoàn thành',
                                        selectedTab == 'Đã hoàn thành'
                                            ? Colors.white
                                            : Colors.black,
                                        14),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          body: snapshot.data!.docs.length == 0
              ? Center(
                  child: getNormalText('Không có đơn hàng', Colors.black, 14),
                )
              : ListView(
                  physics: AlwaysScrollableScrollPhysics(),
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data()! as Map<String, dynamic>;
                    OrderModel order = OrderModel.fromJson(data);
                    return GestureDetector(
                      onTap: () {
                        pushNavigate(
                            context,
                            OrderDetails(
                              order: order,
                              id: document.id,
                            ));
                      },
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              getBoldText(
                                  DateFormat('dd MMMM yy, HH:mm')
                                      .format(order.dateTime),
                                  MyColors.primaryColor,
                                  16),
                              SizedBox(
                                height: 10,
                              ),
                              ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: order.items.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 3),
                                    child: Row(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(100)),
                                          height: 30,
                                          width: 30,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            child: Image.network(
                                                fit: BoxFit.fill,
                                                order.items[index].productModel!
                                                    .imgUrl),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        getNormalText(
                                            '${order.items[index].productModel!.name} x ${order.items[index].quantity}',
                                            Colors.black,
                                            14),
                                      ],
                                    ),
                                  );
                                },
                              ),
                              Divider(),
                              Padding(
                                padding: EdgeInsets.all(5),
                                child: getBoldText(
                                    'Tổng: ${order.totalAmount} ₫',
                                    Colors.black,
                                    15),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
        );
      },
    );
  }
}
