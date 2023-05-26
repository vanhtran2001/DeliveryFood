import 'dart:convert';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/helper/utils.dart';
import 'package:untitled/providers/cart_provider.dart';
import 'package:untitled/screens/home_screen.dart';

import 'admin/api/product_api/user_api.dart';
import 'admin/screens/admin_home_page.dart';
import 'helper/colors.dart';
import 'helper/const.dart';
import 'models/user_model.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => CartProvider()),
  ],
  child: const MyApp(),));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: MyColors.primaryColor,
        scaffoldBackgroundColor: Colors.white
      ),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  splashTimer() async{
    final _auth = FirebaseAuth.instance.currentUser;
    if (_auth != null) {
      var user = await UserApi().getUser(_auth.uid);
      String userString = json.encode(user);

      UserModel userModel = UserModel.fromJson(jsonDecode(userString));
      currentUser = userModel;
    }

    Future.delayed(Duration(seconds: 2)).then((value) {
      currentUser == null
          ? Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomeScreen()))
          : currentUser!.role == 'Admin'
          ? Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => AdminHomePage()))
          : Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => HomeScreen()));
    });
  }

  @override
  void initState() {
    splashTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: getTotalHeight(context),
      child: Image.asset('assets/images/splash1.png',
      fit: BoxFit.fill,),
    );
  }
}
