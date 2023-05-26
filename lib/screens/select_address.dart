import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:untitled/helper/utils.dart';
import 'package:untitled/paypal/payment.dart';
import 'package:untitled/screens/user_detail_screen.dart';

import '../admin/api/coupon_api/coupon_api.dart';
import '../admin/api/delivery_charges_api.dart/delivery_charges_api.dart';
import '../admin/api/order_api.dart/order_api.dart';
import '../helper/colors.dart';
import '../helper/const.dart';
import '../models/cart_model.dart';
import '../models/coupon_model.dart';
import '../models/delivery_charges_model.dart';
import '../models/order_model.dart';
import '../models/user_model.dart';
import '../providers/cart_provider.dart';
import 'order_success.dart';

class SelectAddress extends StatefulWidget {
  const SelectAddress({super.key});

  @override
  State<SelectAddress> createState() => _SelectAddressState();
}

class _SelectAddressState extends State<SelectAddress> {
  List<DeliveryChargeModel> areas = [];
  bool isLoading = false;
  int deliveryCharge = 0;
  String? msg;
  String deliveryType = 'COD';
  var _formKey = GlobalKey<FormState>();
  TextEditingController t1 = TextEditingController();
  CouponModel? usecoupon;
  getAreas() async {
    setState(() {
      isLoading = true;
    });
    List<DeliveryChargeModel> tempList;
    tempList = await DeliveryChargeApi().getArea();
    areas.addAll(tempList);
    setState(() {
      isLoading = false;
    });
  }

  AddressModel? selectedAddress;

  @override
  void initState() {
    getAreas();
    super.initState();
  }

  getDeliveryCharge() {
    DeliveryChargeModel area = areas.firstWhere((element) {
      return element.name == selectedAddress!.area;
    });
    setState(() {
      deliveryCharge = int.parse(area.deliveryCharge);
    });
  }

  addOrder() {
    if (selectedAddress == null) {
      getSnackBar('Vui lòng chọn nơi giao hàng', context);
      return;
    }
    setState(() {
      isLoading = true;
    });
    List<CartModel> items = [];
    Provider.of<CartProvider>(context, listen: false)
        .cartItem
        .forEach((key, value) {
      items.add(value);
    });
    String totalAmount = '0';
    if (usecoupon?.type == 'Percentage') {
      totalAmount = ((Provider.of<CartProvider>(context, listen: false).getTotalPrice() * (usecoupon == null ? 0 : usecoupon!.offAmount) / 100).toInt()  + deliveryCharge).toString();
    } else {
     totalAmount = (Provider.of<CartProvider>(context, listen: false).getTotalPrice() +
                    deliveryCharge -
                  (usecoupon == null ? 0 : usecoupon!.offAmount))
                      .toString();
    }
    OrderModel order = OrderModel(
        userId: currentUser!.id,
        address: selectedAddress!,
        name: currentUser!.name,
        dateTime: DateTime.now(),
        date: DateFormat('dd:MM:yy').format(DateTime.now()),
        items: items,
        phoneNumber: currentUser!.phoneNum,
        totalAmount: totalAmount,
        status: 'Đang giao');
    OrderApi().addOrder(order).then((value) {
      usecoupon != null
          ? CouponApi().getAndUpdateCopon(t1.text).then((value) {
              setState(() {
                isLoading = false;
              });
            })
          : null;
      setState(() {
        isLoading = false;
      });
      Provider.of<CartProvider>(context, listen: false).clearCart();
      pushNavigate(context, OrderSuccess());
    }).onError((error, stackTrace) {
      setState(() {
        isLoading = false;
      });
      print(error);
      getSnackBar(error.toString(), context);
    });
  }

  getCoupon() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        msg = null;
      });
      var coupon = await CouponApi().getCopon(t1.text);
      print(coupon);
      if (coupon == null) {
        setState(() {
          msg = 'Mã không hợp lệ';
        });
        return;
      } else {
        if (coupon.endDate.millisecondsSinceEpoch <
            DateTime.now().millisecondsSinceEpoch) {
          setState(() {
            msg = 'Mã hết hạn';
          });
          return;
        }
        if (coupon.usedById.contains(currentUser!.id)) {
          setState(() {
            msg = 'Mã đã được sử dụng';
          });
          return;
        }
        if (coupon.minAmount >
            Provider.of<CartProvider>(context, listen: false)
                .getTotalPrice()) {
          setState(() {
            msg =
                'Đơn ${coupon.minAmount} là tối thiểu để sử dụng mã giảm giá này';
          });
          return;
        }
      }
      // if all the checks are done, we can now apply the coupon
      setState(() {
        usecoupon = coupon;
        msg = 'Áp mã thành công';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getOtherScreenAppBar('Thanh toán', context),
      bottomSheet: Container(
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      getBoldText('Mã giảm giá', Colors.black, 14),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width / 1.5,
                            height: 30,
                            child: Form(
                              key: _formKey,
                              child: TextFormField(
                                controller: t1,
                                decoration: InputDecoration(
                                  label: getNormalText(
                                      'Mã giảm giá', Colors.black, 14),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                                keyboardType: TextInputType.name,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Bắt buộc nhập';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                          getButton('Áp dụng', Colors.green, () {
                            getCoupon();
                          })
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      deliveryType = 'COD';
                                    });
                                  },
                                  icon: deliveryType == 'COD'
                                      ? Icon(Icons.radio_button_checked)
                                      : Icon(Icons.radio_button_off)),
                              getNormalText('Thanh toán khi nhận hàng', Colors.black, 14),
                            ],
                          ),
                          Row(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      deliveryType = 'E-Pay';
                                    });
                                  },
                                  icon: deliveryType == 'E-Pay'
                                      ? Icon(Icons.radio_button_checked)
                                      : Icon(Icons.radio_button_off)),
                              getNormalText('Thanh toán qua thẻ', Colors.black, 14),
                            ],
                          ),
                        ],
                      ),
                      msg == null
                          ? Container()
                          : getNormalText(msg!, Colors.black, 14),
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          getBoldText('Tiền hàng:', MyColors.primaryColor, 17),
                          getNormalText(
                              '${Provider.of<CartProvider>(context, listen: false).getTotalPrice()} ₫',
                              Colors.black,
                              17)
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          getBoldText('Phí vận chuyển:', Colors.black, 17),
                          getNormalText('$deliveryCharge ₫', Colors.black, 17)
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      usecoupon == null
                          ? Container()
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                getBoldText(
                                    'Mã giảm:', Colors.black, 17),
                                getNormalText(
                                    usecoupon?.type == 'Percentage'
                                    ? '${usecoupon!.offAmount} %'
                                    : '${usecoupon!.offAmount} ₫',
                                  Colors.black,
                                  17)
                              ],
                            ),
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          getBoldText(
                              'Tổng cộng:', MyColors.primaryColor, 17),
                          getBoldText(
                            usecoupon?.type == 'Percentage'
                                ? '${(Provider.of<CartProvider>(context, listen: false).getTotalPrice() * (usecoupon == null ? 0 : usecoupon!.offAmount) / 100).toInt()  + deliveryCharge} ₫'
                                : '${Provider.of<CartProvider>(context, listen: false).getTotalPrice() + deliveryCharge - (usecoupon == null ? 0 : usecoupon!.offAmount)} ₫',
                          Colors.black,
                          17)
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () {
                    if (deliveryType == 'E-Pay') {
                      pushNavigate(context, Payment());
                    } else {
                      addOrder();
                    }
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
                    child: getBoldText('Đặt đơn', Colors.white, 15),
                  ),
                )
              ],
            ),
          )),
      body: isLoading
          ? getLoading()
          : SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: currentUser!.address.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedAddress = currentUser!.address[index];
                              });
                              getDeliveryCharge();
                            },
                            child: Card(
                              elevation:
                                  selectedAddress == currentUser!.address[index]
                                      ? 10
                                      : 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  side: BorderSide(
                                    color: selectedAddress ==
                                            currentUser!.address[index]
                                        ? Colors.blue
                                        : Colors.transparent,
                                  )),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        getBoldText('Địa chỉ:',
                                            MyColors.primaryColor, 15),
                                        getNormalText(
                                            currentUser!.address[index].address,
                                            Colors.black,
                                            14),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        getBoldText(
                                            'Quận:', MyColors.primaryColor, 15),
                                        getNormalText(
                                            currentUser!.address[index].area,
                                            Colors.black,
                                            14),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          pushNavigate(context, UserDetailScreen());
                        },
                        child: getNormalText('Thêm địa chỉ', Colors.blue, 14),
                      ),
                      SizedBox(
                        height: 500,
                      )
                    ],
                  )),
            ),
    );
  }
}
