import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled/helper/colors.dart';
import 'package:untitled/helper/utils.dart';
import 'package:untitled/screens/otp_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  TextEditingController t1 = TextEditingController();
  var _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    t1.text = '+84';
    super.initState();
  }

  bool isLoading = false;

  sendOtp(String mobile) async {
    setState(() {
      isLoading = true;
    });
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: mobile,
      verificationCompleted: (PhoneAuthCredential credential) {
        setState(() {
          isLoading = false;
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        print(e.message);
        setState(() {
          isLoading = false;
        });
        getSnackBar(e.message.toString(), context);
      },
      codeSent: (String verificationId, int? resendToken) {
        pushNavigate(
            context,
            OTPScreen(
              mobileNum: mobile,
              verificationId: verificationId,
            ));
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading? getLoading(): SingleChildScrollView(
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
                        getBoldText('Nhập số điện thoại', Colors.black, 17),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(10)
                          ),
                          child: Form(
                            key: _formKey,
                            child: TextFormField(
                              validator: (value) {
                                if(value!.length != 12){
                                  return 'Vui lòng nhập đúng số điện thoại';
                                }
                                return null;
                              },
                              controller: t1,
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                icon: Icon(Icons.phone_android),
                                enabledBorder: InputBorder.none
                              ),
                            ),
                          ),
                        ),
                        getButton('Gửi OTP', MyColors.primaryColor, () {
                          if(_formKey.currentState!.validate()){
                            //pushNavigate(context, OTPScreen(mobileNum: t1.text,));
                            sendOtp(t1.text);
                          }
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
