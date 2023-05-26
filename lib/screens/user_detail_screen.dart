import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../admin/api/delivery_charges_api.dart/delivery_charges_api.dart';
import '../helper/colors.dart';
import '../helper/const.dart';
import '../helper/utils.dart';
import '../models/delivery_charges_model.dart';
import 'map.dart';

class UserDetailScreen extends StatefulWidget {
  const UserDetailScreen({super.key});

  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  TextEditingController t1 = TextEditingController();
  TextEditingController t2 = TextEditingController();
  String? selectedArea;
  List<DeliveryChargeModel> areas = [];
  bool isLoading = false;
  int deliveryCharge = 0;
  var _formKey = GlobalKey<FormState>();
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

  setName() {
    t1.text = currentUser!.name;
  }

  @override
  void initState() {
    setName();
    getAreas();
    super.initState();
  }
  // lets make name field prefilled

  getDeliveryCharge() {
    DeliveryChargeModel area = areas.firstWhere((element) {
      return element.name == selectedArea!;
    });
    setState(() {
      deliveryCharge = int.parse(area.deliveryCharge);
    });
  }

  saveUserDetails() {
    if (_formKey.currentState!.validate()) {
      pushNavigate(
          context,
          MapScreen(
            address: t2.text,
            area: selectedArea!,
            name: t1.text,
          ));
      //   setState(() {
      //     isLoading = true;
      //   });
      //   // here, we have to append our new address to the exisitng list of addresses
      //   AddressModel addressModel = AddressModel(
      //       address: t2.text,
      //       landmark: t3.text,
      //       area: selectedArea!,
      //       latitude: '',
      //       longitude: '');
      //   List<AddressModel> addresses = currentUser!.address;
      //   addresses.add(addressModel);
      //   UserModel userModel = UserModel(
      //       id: currentUser!.id,
      //       name: t1.text,
      //       phoneNum: currentUser!.phoneNum,
      //       address: addresses,
      //       favProduct: []);
      //   UserApi().updateUser(userModel).then((value) {
      //     setState(() {
      //       isLoading = false;
      //     });
      //     getSnackbar('Address added successfully', context);
      //     Navigator.pop(context);
      //     // great, now lets move further to allow user to select one of the address before placing order
      //   }).onError((error, stackTrace) {
      //     setState(() {
      //       isLoading = false;
      //     });
      //     getSnackbar(error.toString(), context);
      //   });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getOtherScreenAppBar('Thêm địa chỉ giao hàng', context),
      bottomSheet: Container(
          // padding: EdgeInsets.all(10),
          width: MediaQuery.of(context).size.width,
          child: IntrinsicHeight(
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    saveUserDetails();
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
                    child: getBoldText('Lưu', Colors.white, 15),
                  ),
                )
              ],
            ),
          )),
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
                      getBoldText('Tên', Colors.black, 13),
                      SizedBox(
                        height: 3,
                      ),
                      TextFormField(
                        controller: t1,
                        decoration: InputDecoration(
                          label: getNormalText('Tên', Colors.black, 14),
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
                      SizedBox(
                        height: 20,
                      ),
                      getBoldText('Địa chỉ', Colors.black, 13),
                      SizedBox(
                        height: 3,
                      ),
                      TextFormField(
                        controller: t2,
                        decoration: InputDecoration(
                          label: getNormalText('Địa chỉ', Colors.black, 14),
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
                      // a dropdown for area
                      SizedBox(
                        height: 20,
                      ),
                      getBoldText('Quận', Colors.black, 13),
                      SizedBox(
                        height: 3,
                      ),
                      Container(
                        height: 60,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(5)),
                        child: DropdownButton(
                          borderRadius: BorderRadius.circular(10),
                          isExpanded: true,
                          itemHeight: 60,
                          elevation: 0,
                          value: selectedArea,
                          underline: Container(),
                          hint: getNormalText('Chọn quận', Colors.black, 14),
                          items: areas.map((DeliveryChargeModel value) {
                            return DropdownMenuItem<String>(
                                value: value.name,
                                child: getNormalText(
                                    value.name, Colors.black, 14));
                          }).toList(),
                          onChanged: (_) {
                            setState(() {
                              selectedArea = _ as String?;
                            });
                            getDeliveryCharge();
                          },
                        ),
                      ),
                      Container(
                        height: 200,
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
