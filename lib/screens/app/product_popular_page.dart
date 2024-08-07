import 'package:flutter/material.dart';
import 'package:highlandcoffeeapp/apis/api.dart';
import 'package:highlandcoffeeapp/models/model.dart';
import 'package:highlandcoffeeapp/screens/app/cart_page.dart';
import 'package:highlandcoffeeapp/screens/app/product_detail_page.dart';
import 'package:highlandcoffeeapp/themes/theme.dart';
import 'package:highlandcoffeeapp/widgets/product_form.dart';
import 'package:highlandcoffeeapp/widgets/custom_app_bar.dart';
import 'package:highlandcoffeeapp/widgets/custom_bottom_navigation_bar.dart';

class ProductPopularPage extends StatefulWidget {
  const ProductPopularPage({super.key});

  @override
  State<ProductPopularPage> createState() => _ProductPopularPageState();
}

class _ProductPopularPageState extends State<ProductPopularPage> {
  Future<String> categoryNameFuture = Future.value('Sản phẩm phổ biến');
  int _selectedIndexBottomBar = 1;
  Future<List<Product>>? productsFuture;

  final SystemApi systemApi = SystemApi();

  void _selectedBottomBar(int index) {
    setState(() {
      _selectedIndexBottomBar = index;
    });
  }

  @override
  void initState() {
    super.initState();
    productsFuture = systemApi.getPopulars();
  }

  void _navigateToProductDetails(int index, List<Product> products) async {
    List<Map<String, dynamic>> productSizes =
        await _getProductSizes(products[index].productname);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailPage(
          product: products[index],
          productSizes: productSizes,
        ),
      ),
    );
  }

  Future<List<Map<String, dynamic>>> _getProductSizes(String productname) async {
  try {
    List<Map<String, dynamic>> sizes = await systemApi.getProductSizes(productname);
    return sizes;
  } catch (e) {
    print("Error fetching product sizes: $e");
    return [];
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: CustomAppBar(
        futureTitle: categoryNameFuture,
        actions: [
          AppBarAction(
            icon: Icons.shopping_cart,
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => CartPage(),
              ));
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Product>>(
        future: productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            List<Product> products = snapshot.data ?? [];
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 18.0, top: 18.0, right: 18.0),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 18.0,
                    mainAxisSpacing: 18.0,
                    childAspectRatio: 0.64,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) => ProductForm(
                    product: products[index],
                    onTap: () => _navigateToProductDetails(index, products),
                  ),
                ),
              ),
            );
          }
        },
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndexBottomBar,
        onTap: _selectedBottomBar,
      ),
    );
  }
}