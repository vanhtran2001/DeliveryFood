import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:untitled/helper/utils.dart';

import '../../models/coupon_model.dart';
import '../api/coupon_api/coupon_api.dart';

class AddCoupon extends StatefulWidget {
  const AddCoupon({super.key});

  @override
  State<AddCoupon> createState() => _AddCouponState();
}

class _AddCouponState extends State<AddCoupon> {
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  String couponType = 'Flat';
  var _formKey = GlobalKey<FormState>();
  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: startDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != startDate) {
      setState(() {
        startDate = picked;
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: endDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != endDate) {
      setState(() {
        endDate = picked;
      });
    }
  }

  TextEditingController t1 = TextEditingController();
  TextEditingController t3 = TextEditingController();
  TextEditingController t2 = TextEditingController();
  TextEditingController t4 = TextEditingController();
  bool isLoading = false;
  saveCoupon() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      CouponModel couponModel = CouponModel(
          name: t1.text,
          description: t3.text,
          type: couponType,
          startDate: startDate,
          endDate: endDate,
          minAmount: int.parse(t4.text),
          offAmount: int.parse(t2.text),
          usedById: []);
      CouponApi().addCoupon(couponModel).then((value) {
        setState(() {
          isLoading = false;
        });
      }).onError((error, stackTrace) {
        setState(() {
          isLoading = false;
        });
      });
      getSnackBar('Lưu mã giảm giá thành công', context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getOtherScreenAppBar('Thêm mã giảm giá', context),
      body: isLoading
          ? getLoading()
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      getBoldText('Tên mã giảm giá', Colors.black, 13),
                      SizedBox(
                        height: 3,
                      ),
                      TextFormField(
                        controller: t1,
                        decoration: InputDecoration(
                          label: getNormalText('Tên mã giảm giá', Colors.black, 14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Bắt buộc nhập';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      getBoldText('Tên mã giảm giá', Colors.black, 13),
                      SizedBox(
                        height: 3,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      couponType = 'Flat';
                                    });
                                  },
                                  icon: couponType == 'Flat'
                                      ? Icon(Icons.radio_button_checked)
                                      : Icon(Icons.radio_button_off)),
                              getNormalText('Giảm tiền', Colors.black, 14),
                            ],
                          ),
                          Row(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      couponType = 'Percentage';
                                    });
                                  },
                                  icon: couponType == 'Percentage'
                                      ? Icon(Icons.radio_button_checked)
                                      : Icon(Icons.radio_button_off)),
                              getNormalText('Phẩn trăm', Colors.black, 14),
                            ],
                          ),
                        ],
                      ),
                      getBoldText(
                          couponType == 'Percentage'
                              ? 'Phần trăm giảm'
                              : 'Tiền giảm',
                          Colors.black,
                          13),
                      SizedBox(
                        height: 3,
                      ),
                      TextFormField(
                        controller: t2,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          label: getNormalText(
                              couponType == 'Percentage'
                                  ? 'Phần trăm giảm'
                                  : 'Tiền giảm',
                              Colors.black,
                              14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Bắt buộc nhập';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      getBoldText('Đơn tối thiểu', Colors.black, 13),
                      SizedBox(
                        height: 3,
                      ),
                      TextFormField(
                        controller: t4,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          label:
                              getNormalText('Đơn tối thiểu', Colors.black, 14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Bắt buộc nhập';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      getBoldText('Mô tả', Colors.black, 13),
                      SizedBox(
                        height: 3,
                      ),
                      TextFormField(
                        controller: t3,
                        keyboardType: TextInputType.multiline,
                        minLines: 3,
                        maxLines: 5,
                        decoration: InputDecoration(
                          label: getNormalText('Mô tả', Colors.black, 14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Bắt buộc nhập';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          getBoldText('Ngày bắt đầu:', Colors.black, 14),
                          Row(
                            children: [
                              getNormalText(
                                  DateFormat('dd MMMM, yy').format(startDate),
                                  Colors.black,
                                  14),
                              IconButton(
                                  onPressed: () {
                                    _selectStartDate(context);
                                  },
                                  icon: Icon(Icons.calendar_today))
                            ],
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          getBoldText('Ngày kết thúc:', Colors.black, 14),
                          Row(
                            children: [
                              getNormalText(
                                  DateFormat('dd MMMM, yy').format(endDate),
                                  Colors.black,
                                  14),
                              IconButton(
                                  onPressed: () {
                                    _selectEndDate(context);
                                  },
                                  icon: Icon(Icons.calendar_today))
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: getButton('Lưu mã giảm giá', Colors.green, () {
                          saveCoupon();
                        }),
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
