import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled/admin/screens/product_screen.dart';

import 'order_screen.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({Key? key}) : super(key: key);

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  int _page = 0;
  List<Widget> pages = [
    OrderScreen(),
    ProductScreen(),
  ];
  onPageChange(int page){
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_page],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onPageChange,
        currentIndex: _page,
        items: [
          BottomNavigationBarItem(
            label: 'Đơn hàng',
            icon: Icon(Icons.shopping_bag),
          ),
          BottomNavigationBarItem(
            label: 'Sản phẩm',
            icon: Icon(Icons.onetwothree),
          ),
        ],
      ),
    );
  }
}
