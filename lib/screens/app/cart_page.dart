import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highlandcoffeeapp/apis/api.dart';
import 'package:highlandcoffeeapp/auth/auth_manage.dart';
import 'package:highlandcoffeeapp/models/model.dart';
import 'package:highlandcoffeeapp/screens/app/order_page.dart';
import 'package:highlandcoffeeapp/widgets/custom_app_bar.dart';
import 'package:highlandcoffeeapp/widgets/custom_bottom_navigation_bar.dart';
import 'package:highlandcoffeeapp/themes/theme.dart';
import 'package:highlandcoffeeapp/widgets/cart_product_form.dart';

class CartPage extends StatefulWidget {
  const CartPage();

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  Future<String> categoryNameFuture = Future.value('Giỏ hàng');
  int _selectedIndexBottomBar = 3;
  late List<CartItem> cartItems = [];
  SystemApi systemApi = SystemApi();
  Customer? loggedInUser = AuthManager().loggedInCustomer;

  void _selectedBottomBar(int index) {
    setState(() {
      _selectedIndexBottomBar = index;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchCartItems();
  }

  bool isValidBase64(String value) {
    try {
      base64.decode(value);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> fetchCartItems() async {
    try {
      List<dynamic> jsonResponse = await systemApi.fetchCartDetails();
      List<dynamic> items = jsonResponse.map((data) {

        if (data['customerid'] == loggedInUser?.customerid) {

          return CartItem(
            data['cartdetailid'],
            data['cartid'],
            data['customerid'],
            data['productid'],
            data['productname'],
            data['size'],
            data['quantity'],
            data['totalprice'],
            data['image'],
          );
        }
      }).toList();

      bool hasItems = items.any((item) => item != null);
      if (!hasItems) {
        items = [];
      }

      setState(() {
        cartItems =
            items.where((item) => item != null).cast<CartItem>().toList();
      });
    } catch (e) {
      print('Error fetching cart items: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: CustomAppBar(
        futureTitle : categoryNameFuture,
        actions: [
          AppBarAction(
            icon: Icons.shopping_cart_checkout,
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => OrderPage(
                  cartItems: cartItems,
                ),
              ));
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 18.0, top: 18.0, right: 18.0),
        child: Column(
          children: [
            Center(
              child: Text(
                'Giảm giá 20% cho những khách hàng có 100 điểm',
                style: GoogleFonts.roboto(
                  color: grey,
                  fontSize: 17,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            cartItems.isEmpty
                ? Column(
                    children: [
                      SizedBox(
                        height: 300,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Giỏ hàng trống, mua sắm ngay',
                            style: GoogleFonts.roboto(
                              color: black,
                              fontSize: 19,
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Icon(
                            Icons.production_quantity_limits,
                            color: primaryColors,
                            size: 25,
                          )
                        ],
                      )
                    ],
                  )
                : Column(
                    children: [
                      CartProductForm(
                          cartItems: cartItems,
                          onDelete: () => fetchCartItems()),
                    ],
                  ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndexBottomBar,
        onTap: _selectedBottomBar,
      ),
    );
  }
}

class CartItem {
  final String cartdetailid;
  final String cartid;
  final String customerid;
  final String productid;
  final String productname;
  final String size;
  final int quantity;
  final int totalprice;
  String image;

  CartItem(
    this.cartdetailid,
    this.cartid,
    this.customerid,
    this.productid,
    this.productname,
    this.size,
    this.quantity,
    this.totalprice,
    this.image,
  );
}
