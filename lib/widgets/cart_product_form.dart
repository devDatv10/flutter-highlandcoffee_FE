import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highlandcoffeeapp/screens/app/cart_page.dart';
import 'package:highlandcoffeeapp/themes/theme.dart';

class CartProductForm extends StatefulWidget {
  final List<CartItem> cartItems;
  const CartProductForm({Key? key, required this.cartItems}) : super(key: key);

  @override
  State<CartProductForm> createState() => _CartProductFormState();
}

class _CartProductFormState extends State<CartProductForm> {
  // Hàm để xóa sản phẩm từ giỏ hàng
  void deleteProductFromCart(int index) async {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(
            "Thông báo",
            style: GoogleFonts.arsenal(
              color: primaryColors,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          content:
              Text("Bạn có chắc muốn xóa sản phẩm này khỏi giỏ hàng không?"),
          actions: [
            CupertinoDialogAction(
              isDestructiveAction: true,
              child: Text("Xóa"),
              onPressed: () async {
                // Thực hiện xóa sản phẩm từ cả giỏ hàng và Firestore
                setState(() {
                  widget.cartItems.removeAt(index);
                });

                await removeFromFirestore(index);

                Navigator.pop(context);
                _showAlert(
                    'Thông báo', 'Xóa sản phẩm khỏi giỏ hàng thành công.');
              },
            ),
            CupertinoDialogAction(
              child: Text(
                "Hủy",
                style: TextStyle(color: blue),
              ),
              onPressed: () {
                Navigator.pop(context); // Đóng hộp thoại
              },
            ),
          ],
        );
      },
    );
  }

// Hàm để xóa sản phẩm từ cơ sở dữ liệu Firestore
  Future<void> removeFromFirestore(int index) async {
    try {
      // Lấy ID của sản phẩm trong Firestore
      String productId = await getProductId(index);

      // Thực hiện xóa sản phẩm từ Firestore
      await FirebaseFirestore.instance
          .collection('Giỏ hàng')
          .doc(productId)
          .delete();

      print('Product removed from Firestore successfully!');
    } catch (e) {
      print('Error removing product from Firestore: $e');
    }
  }

// Hàm để lấy ID của sản phẩm từ Firestore dựa trên index
  Future<String> getProductId(int index) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance.collection('Giỏ hàng').get();

      // Lấy ID của sản phẩm trong Firestore
      String productId = querySnapshot.docs[index].id;

      return productId;
    } catch (e) {
      print('Error getting product ID from Firestore: $e');
      return '';
    }
  }

//
  void _showAlert(String title, String content) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(
            title,
            style: GoogleFonts.arsenal(color: primaryColors),
          ),
          content: Text(content),
          actions: <Widget>[
            CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'OK',
                style: TextStyle(color: blue),
              ),
            ),
          ],
        );
      },
    );
  }

  // Hàm kiểm tra xem một chuỗi có đúng định dạng base64 hay không
  bool isValidBase64(String value) {
    try {
      base64.decode(value);
      print('Decoding base64 is successful!');
      return true;
    } catch (e) {
      print('Error decoding base64: $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 650,
          child: ListView.builder(
            scrollDirection: Axis.vertical, // Để cho phép cuộn theo chiều ngang
            itemCount: widget.cartItems.length,
            itemBuilder: (context, index) {
              var item = widget.cartItems[index];
              return Slidable(
                startActionPane: ActionPane(motion: StretchMotion(), children: [
                  SlidableAction(
                    onPressed: ((context) {
                      Get.toNamed('/home_page');
                    }),
                    borderRadius: BorderRadius.circular(18.0),
                    backgroundColor: Colors.transparent,
                    foregroundColor: blue,
                    label: 'Trang chủ',
                    icon: Icons.home,
                  )
                ]),
                endActionPane: ActionPane(motion: StretchMotion(), children: [
                  SlidableAction(
                    onPressed: ((context) {
                      //comand delete
                      deleteProductFromCart(index);
                    }),
                    borderRadius: BorderRadius.circular(18.0),
                    backgroundColor: Colors.transparent,
                    foregroundColor: red,
                    label: 'Xóa',
                    icon: Icons.delete,
                  ),
                ]),
                child: Container(
                  margin: EdgeInsets.symmetric(
                      vertical: 10), // Khoảng cách giữa các Container
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // if(isValidBase64(item.product_image))
                        // Image.memory(
                        //   base64Decode(item.product_image),
                        //   height: 70.0,
                        //   width: 70.0,
                        // ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.product_name,
                              style: GoogleFonts.arsenal(
                                  fontSize: 18,
                                  color: primaryColors,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              item.selected_price.toStringAsFixed(3) + 'đ',
                              style: GoogleFonts.roboto(
                                color: primaryColors,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            // Text('Quantity: ${item.quantity}'),
                            Row(
                              children: [
                                Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                        color: primaryColors,
                                        shape: BoxShape.circle),
                                    child: GestureDetector(
                                      onTap: () {
                                        // Xử lý khi nhấn nút giảm
                                      },
                                      child: Icon(
                                        Icons.remove,
                                        size: 15,
                                        color: white,
                                      ),
                                    )),
                                //quantity + count
                                SizedBox(
                                  width: 35,
                                  child: Center(
                                    child: Text(
                                      item.quantity.toString(),
                                      style: GoogleFonts.roboto(
                                          fontSize: 15, color: black),
                                    ),
                                  ),
                                ),
                                Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                        color: primaryColors,
                                        shape: BoxShape.circle),
                                    child: GestureDetector(
                                      onTap: () {
                                        // Xử lý khi nhấn nút thêm
                                      },
                                      child: Icon(
                                        Icons.add,
                                        size: 15,
                                        color: white,
                                      ),
                                    ))
                              ],
                            )
                          ],
                        ),
                        Column(
                          children: [
                            // Text('Size: ${item.selectedSize}'),
                            Container(
                              height: 25,
                              width: 50,
                              decoration: BoxDecoration(
                                color: white,
                                borderRadius: BorderRadius.circular(18.0),
                                border: Border.all(
                                  color: primaryColors,
                                  width: 1,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  item.selected_size,
                                  style: GoogleFonts.arsenal(
                                      color: primaryColors,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}