import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highlandcoffeeapp/apis/api.dart';
import 'package:highlandcoffeeapp/auth/auth_manage.dart';
import 'package:highlandcoffeeapp/models/model.dart';
import 'package:highlandcoffeeapp/widgets/button_add_to_cart.dart';
import 'package:highlandcoffeeapp/widgets/button_buy_now.dart';
import 'package:highlandcoffeeapp/screens/app/cart_page.dart';
import 'package:highlandcoffeeapp/themes/theme.dart';
import 'package:highlandcoffeeapp/widgets/custom_alert_dialog.dart';
import 'package:highlandcoffeeapp/widgets/size_product.dart';
import 'package:photo_view/photo_view.dart';

class ProductDetailPage extends StatefulWidget {
  final List<Map<String, dynamic>> productSizes;
  final Product product;
  const ProductDetailPage(
      {super.key, required this.product, required this.productSizes});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int quantityCount = 1;
  int totalPrice = 0;
  bool isFavorite = false;
  String selectedSize = '';
  Customer? loggedInUser = AuthManager().loggedInCustomer;
  final SystemApi systemApi = SystemApi();

  @override
  void initState() {
    super.initState();
    selectedSize = widget.product.size;
    updateTotalPrice();
  }

  void decrementQuantity() {
    setState(() {
      if (quantityCount > 1) {
        quantityCount--;
        updateTotalPrice();
      }
    });
  }

  void incrementQuantity() {
    setState(() {
      quantityCount++;
      updateTotalPrice();
    });
  }

  void updateTotalPrice() {
    setState(() {
      totalPrice = getPriceForSelectedSize() * quantityCount;
    });
  }

  int getPriceForSelectedSize() {
    for (var size in widget.productSizes) {
      if (size['size'] == selectedSize) {
        return size['price'];
      }
    }
    return 0;
  }

  void _showConfirmationDialog() {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(
            "Thông báo",
            style: GoogleFonts.roboto(
              color: primaryColors,
              fontWeight: FontWeight.bold,
              fontSize: 19,
            ),
          ),
          content: Text("Thêm sản phẩm này vào danh sách sản phẩm yêu thích?",
              style: GoogleFonts.roboto(
                color: black,
                fontSize: 16,
              )),
          actions: [
            CupertinoDialogAction(
              isDestructiveAction: true,
              child: Text("OK",
                  style: GoogleFonts.roboto(
                      color: blue, fontSize: 17, fontWeight: FontWeight.bold)),
              onPressed: () async {
                addToFavorites();
                setState(() {
                  isFavorite = !isFavorite;
                });
                Navigator.pop(context);
              },
            ),
            CupertinoDialogAction(
              child: Text(
                "Hủy",
                style: GoogleFonts.roboto(color: blue, fontSize: 17),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void addToFavorites() async {
    try {
      Uint8List image = base64Decode(widget.product.image);
      Uint8List imageDetail = base64Decode(widget.product.imagedetail);

      String base64Image = base64Encode(image);
      String base64ImageDetail = base64Encode(imageDetail);

      Favorite favorite = Favorite(
        favoriteid: '',
        customerid: loggedInUser!.customerid!,
        productid: widget.product.productid,
        productname: widget.product.productname,
        description: widget.product.description,
        size: selectedSize,
        price: widget.product.price,
        unit: widget.product.unit,
        image: base64Image,
        imagedetail: base64ImageDetail,
      );

      await systemApi.addFavorite(favorite);
      showCustomAlertDialog(
          context, 'Thành công', 'Đã thêm sản phẩm vào danh sách yêu thích');
    } catch (e) {
      print(e);
      showCustomAlertDialog(
          context, 'Lỗi', 'Không thể thêm sản phẩm vào danh sách yêu thích');
    }
  }

  Future<void> addToCart() async {
    try {
      Uint8List image = base64Decode(widget.product.image);
      String base64Image = base64Encode(image);

      Cart newCart = Cart(
          cartdetailid: '',
          cartid: '',
          customerid: loggedInUser!.customerid!,
          productid: widget.product.productid,
          quantity: quantityCount,
          image: base64Image,
          productname: widget.product.productname,
          totalprice: totalPrice,
          size: selectedSize);

      await systemApi.addCart(newCart);
      showCustomAlertDialog(
          context, 'Thành công', 'Đã thêm sản phẩm vào giỏ hàng');
          // fix lại khi thêm sản phẩm thành công vào giỏ hàng nhấn Ok sẽ navigate qua trang Giỏ hàng
    } catch (e) {
      print(e);
      showCustomAlertDialog(
          context, 'Lỗi', 'Không thể thêm sản phẩm vào giỏ hàng');
    }
  }

  void showImageProduct(BuildContext context, Uint8List image) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: 300,
          height: 350,
          child: PhotoView(
            backgroundDecoration:
                const BoxDecoration(color: Colors.transparent),
            imageProvider: MemoryImage(image),
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.covered * 2,
            initialScale: PhotoViewComputedScale.contained,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Uint8List image = base64Decode(widget.product.image);
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Stack(
                children: [
                  Image.memory(
                    widget.product.imagedetail != null
                        ? base64Decode(widget.product.imagedetail)
                        : Uint8List(0),
                  ),
                  Positioned(
                    top: 54,
                    left: 8,
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: white,
                      ),
                      onPressed: () {
                        Get.back();
                      },
                    ),
                  ),
                  Positioned(
                    top: 54,
                    right: 8,
                    child: IconButton(
                      icon: Icon(
                        Icons.shopping_cart,
                        color: white,
                      ),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const CartPage(),
                        ));
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 150),
            ],
          ),
          Positioned(
            top: 415,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 18.0, right: 18.0),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 15.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.product.productname.toUpperCase(),
                          style: GoogleFonts.arsenal(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: primaryColors),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                            onTap: () {
                              _showConfirmationDialog();
                            },
                            child: Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: primaryColors,
                              size: 30,
                            ))
                      ],
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () => showImageProduct(context, image),
                          onDoubleTap: () => showImageProduct(context, image),
                          child: MouseRegion(
                            onEnter: (_) => showImageProduct(context, image),
                            child: Image.memory(
                              image,
                              width: 85,
                              height: 85,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Expanded(
                          child: SizedBox(
                            height: 120,
                            child: Text(
                              widget.product.description,
                              style: GoogleFonts.roboto(
                                  fontSize: 17, color: black),
                              maxLines: 5,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    //product size
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Chọn Size',
                          style: GoogleFonts.arsenal(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              color: black),
                        ),
                        SizeProducts(
                          titleSize: 'S',
                          isSelected: selectedSize == 'S',
                          onSizeSelected: (size) {
                            setState(() {
                              selectedSize = size;
                              updateTotalPrice();
                            });
                          },
                        ),
                        SizeProducts(
                          titleSize: 'M',
                          isSelected: selectedSize == 'M',
                          onSizeSelected: (size) {
                            setState(() {
                              selectedSize = size;
                              updateTotalPrice();
                            });
                          },
                        ),
                        SizeProducts(
                          titleSize: 'L',
                          isSelected: selectedSize == 'L',
                          onSizeSelected: (size) {
                            setState(() {
                              selectedSize = size;
                              updateTotalPrice();
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    //product quantity
                    Row(
                      children: [
                        Text(
                          'Số lượng ',
                          style: GoogleFonts.arsenal(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              color: black),
                        ),
                        const SizedBox(width: 50),
                        Row(
                          children: [
                            Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                    color: lightGrey, shape: BoxShape.circle),
                                child: GestureDetector(
                                  onTap: decrementQuantity,
                                  child: Icon(
                                    Icons.remove,
                                    size: 19,
                                    color: white,
                                  ),
                                )),
                            //quantity + count
                            SizedBox(
                              width: 35,
                              child: Center(
                                child: Text(
                                  quantityCount.toString(),
                                  style: GoogleFonts.roboto(
                                      fontSize: 17, color: black),
                                ),
                              ),
                            ),
                            Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                    color: primaryColors,
                                    shape: BoxShape.circle),
                                child: GestureDetector(
                                  onTap: incrementQuantity,
                                  child: Icon(
                                    Icons.add,
                                    size: 19,
                                    color: white,
                                  ),
                                ))
                          ],
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    //product price
                    Row(
                      children: [
                        Text(
                          'Tổng tiền',
                          style: GoogleFonts.arsenal(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              color: black),
                        ),
                        const SizedBox(
                          width: 50,
                        ),
                        Text(
                          totalPrice == 0
                              ? 'Chưa có giá'
                              : totalPrice.toStringAsFixed(3) + 'đ',
                          style: GoogleFonts.roboto(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: primaryColors,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Text(
                          'Đơn vị tính ',
                          style: GoogleFonts.arsenal(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              color: black),
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        Text(
                          '${widget.product.unit}',
                          style: GoogleFonts.roboto(fontSize: 19, color: black),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    //button add to cart and buy now
                    IntrinsicHeight(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ButtonAddToCart(
                            text: 'Thêm vào giỏ',
                            onTap: () {
                              addToCart();
                            },
                          ),
                          VerticalDivider(
                            color: lightBrown,
                            thickness: 1,
                          ),
                          ButtonBuyNow(
                              text: 'Mua ngay',
                              onTap: () {
                                addToCart();
                              }),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
