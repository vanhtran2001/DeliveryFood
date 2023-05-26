import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled/helper/colors.dart';
import 'package:untitled/helper/const.dart';
import 'package:untitled/helper/utils.dart';
import 'package:untitled/models/user_model.dart';
import 'package:untitled/screens/home_screen.dart';

import '../admin/api/product_api/user_api.dart';
import '../admin/screens/admin_home_page.dart';

class OTPScreen extends StatefulWidget {
  final String mobileNum, verificationId;
  const OTPScreen({Key? key, required this.mobileNum, required this.verificationId}) : super(key: key);

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {

  TextEditingController t1 = TextEditingController();
  bool isLoading = false;
  setUser(var fetchUser) {
    setState(() {
      isLoading = false;
    });
    currentUser = fetchUser;
    currentUser!.role == 'Admin'
        ? pushAndRemoveNavigate(context, AdminHomePage())
        : pushAndRemoveNavigate(context, HomeScreen());
  }
  verifyOtp(String otp) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    setState(() {
      isLoading = true;
    });
    PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId, smsCode: otp);

    var result = await auth.signInWithCredential(phoneAuthCredential);

    var fetchUser;
    fetchUser = await UserApi().getUser(result.user!.uid);
    fetchUser != null
        ? setUser(fetchUser)
        : UserApi()
        .addUser(
      UserModel(
          id: result.user!.uid,
          name: '',
          phoneNum: widget.mobileNum,
          address: [],
          favProduct: [],
          role: 'User'),
    )
        .then((value) {
      currentUser = UserModel(
          id: result.user!.uid,
          name: '',
          phoneNum: widget.mobileNum,
          address: [],
          favProduct: [],
          role: 'User');
      setState(() {
        isLoading = false;
      });
      currentUser!.role == 'Admin'
          ? pushAndRemoveNavigate(context, AdminHomePage())
          : pushAndRemoveNavigate(context, HomeScreen());
    }).catchError((e) {
      setState(() {
        isLoading = false;
      });
      getSnackBar(e, context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset('assets/images/splash1.png', fit: BoxFit.fill,),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              offset: Offset(0, 10),
                              color: Colors.grey,
                              blurRadius: 5
                          )
                        ],
                        borderRadius: BorderRadius.circular(10)
                    ),
                    height: MediaQuery.of(context).size.width,
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              height: MediaQuery.of(context).size.width / 2,
                              child: Image.asset('assets/images/icon.png')
                          ),
                          getBoldText('Một mã OTP đã được gửi đến ${widget.mobileNum}', Colors.black, 17),
                          Container(
                            decoration: BoxDecoration(
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: TextField(
                              controller: t1,
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  icon: Icon(Icons.onetwothree),
                                  enabledBorder: InputBorder.none
                              ),
                            ),
                          ),
                          getButton('Đăng nhập', MyColors.primaryColor, () {
                            verifyOtp(t1.text);
                          })
                        ],
                      ),
                    )
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
