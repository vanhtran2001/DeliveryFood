import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled/admin/screens/admin_home_page.dart';
import 'package:untitled/helper/carousel.dart';
import 'package:untitled/helper/colors.dart';
import 'package:untitled/helper/utils.dart';
import 'package:untitled/screens/login_screen.dart';
import 'package:untitled/screens/product_list.dart';

import '../admin/api/banner_api.dart';
import '../helper/const.dart';
import 'orders_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? bannerUrl;
  bool isLoading = false;
  callAPi() async {
    setState(() {
      isLoading = true;
    });
    bannerUrl = await BannerAPi().getBanner();
    setState(() {
      isLoading = false;
    });
    print(bannerUrl);
  }

  @override
  void initState() {
    callAPi();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getHomeScreenAppBar(context),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              padding: EdgeInsets.zero,
                child: Container(
                  alignment: Alignment.bottomLeft,
              decoration: BoxDecoration(
                color: MyColors.primaryColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20)
                )
              ),
              height: MediaQuery.of(context).size.width,
              child: Padding(
                padding: EdgeInsets.all(8),
                child: getNormalText('Xin chào', Colors.white, 16),
              ),
            )),
            ListTile(
              leading: Icon(
                Icons.home,
                color: Colors.grey,
              ),
              title: getNormalText('Trang chủ', Colors.black, 16),
              onTap: (){
                Navigator.pop(context);
              },
            ),
            currentUser == null ? Container() : Divider(),
            currentUser == null
                ? Container()
                : ListTile(
              leading: Icon(
                Icons.home,
                color: Colors.grey,
              ),
              title: getNormalText('Đơn hàng', Colors.black, 16),
              onTap: () {
                pushNavigate(context, UserOrderScreen());
              },
            ),
            Divider(),
            FirebaseAuth.instance.currentUser == null
                ? ListTile(
              leading: Icon(
                Icons.login,
                color: Colors.grey,
              ),
              title: getNormalText('Đăng nhập', Colors.black, 16),
              onTap: () {
                pushNavigate(context, LoginScreen());
              },
            )
                : ListTile(
              leading: Icon(
                Icons.logout,
                color: Colors.grey,
              ),
              title: getNormalText('Đăng xuất', Colors.black, 16),
              onTap: () {
                currentUser = null;
                FirebaseAuth.instance.signOut();
                pushAndRemoveNavigate(context, HomeScreen());
              },
            ),
            Divider(),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            getTopSection(),
            Carousel(),
            Padding(
              padding: EdgeInsets.all(8),
              child: getBoldText(
                  'Khám phá danh mục',
                  Colors.black,
                  18
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                    getCatCard(context, 'Spaghetti', 'assets/images/monau1.jpg', (){
                      pushNavigate(context, ProductList(title: 'Món Âu'));
                    }),
                    getCatCard(context, 'Su kem', 'assets/images/banhau1.jpg', (){
                      pushNavigate(context, ProductList(title: 'Bánh Âu'));
                    }),
                  ]),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        getCatCard(context, 'Bánh đa cua', 'assets/images/monviet1.jpg', (){
                          pushNavigate(context, ProductList(title: 'Món Việt'));
                        }),
                        getCatCard(context, 'Bánh cam lúc lẵc', 'assets/images/banhviet1.jpg', (){
                          pushNavigate(context, ProductList(title: 'Bánh Việt'));
                        }),
                      ]),
                ],
              ),
            ),
            SizedBox(
              height: 50,
            )
          ],
        ),
      ),
    );
  }

  GestureDetector getCatCard(BuildContext context, String title, String imgUrl, VoidCallback voidCallback) {
    return GestureDetector(
      onTap: voidCallback,
      child: Column(
        children: [
          Container(
            width: getTotalWidth(context) / 2.3,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(imgUrl,
              height: 200,),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          getBoldText(title, Colors.black, 16),
        ],
      ),
    );
  }

  Row getTopSection() {
    return Row(
      children: [
        Flexible(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: GestureDetector(
              onTap: (){
                pushNavigate(context, ProductList(title: 'Món Việt'));
              },
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(200),
                    child: Image.asset('assets/images/categories1.png'),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text('Món Việt',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: GestureDetector(
              onTap: (){
                pushNavigate(context, ProductList(title: 'Bánh Việt'));
              },
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(200),
                    child: Image.asset('assets/images/categories2.png'),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text('Bánh Việt',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: GestureDetector(
              onTap: (){
                pushNavigate(context, ProductList(title: 'Món Âu'));
              },
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(200),
                    child: Image.asset('assets/images/categories3.png'),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text('Món Âu',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: GestureDetector(
              onTap: (){
                pushNavigate(context, ProductList(title: 'Bánh Âu'));
              },
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(200),
                    child: Image.asset('assets/images/categories4.png'),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text('Bánh Âu',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
