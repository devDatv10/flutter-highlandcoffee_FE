import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highlandcoffeeapp/apis/api.dart';
import 'package:highlandcoffeeapp/models/model.dart';
import 'package:highlandcoffeeapp/themes/theme.dart';
import 'package:highlandcoffeeapp/widgets/custom_alert_dialog.dart';
import 'package:highlandcoffeeapp/widgets/labeled_text_field.dart';
import 'package:highlandcoffeeapp/widgets/my_button.dart';

class UpdateCategoryPage extends StatefulWidget {
  static const String routeName = '/update_category_page';
  const UpdateCategoryPage({Key? key}) : super(key: key);

  @override
  State<UpdateCategoryPage> createState() => _UpdateCategoryPageState();
}

class _UpdateCategoryPageState extends State<UpdateCategoryPage> {
  final SystemApi systemApi = SystemApi();
  List<Category> categories = [];
  List<Category> filteredCategories = [];
  final _textSearchCategoryController = TextEditingController();
  TextEditingController _editCategoryNameController = TextEditingController();
  TextEditingController _editDescriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    try {
      List<Category> fetchedCategories = await systemApi.getCategories();
      setState(() {
        categories = fetchedCategories;
        filteredCategories = fetchedCategories;
      });
    } catch (e) {
      print('Error fetching categories: $e');
    }
  }

  // Tạo một hàm để cập nhật danh mục
  Future<void> updateCategory(Category category) async {
    try {
      await systemApi.updateCategory(category);
      Navigator.pop(context);
      showCustomAlertDialog(
          context, 'Thông báo', 'Cập nhật danh mục thành công');
      _fetchCategories();
    } catch (e) {
      showCustomAlertDialog(
          context, 'Lỗi', 'Cập nhật danh mục thất bại. Vui lòng thử lại.');
      print('Error updating category: $e');
    }
  }

  //update product
  void _showUpdateCategoryForm(BuildContext context, Category category) {
    // Điền các giá trị hiện tại của  danh mục vào các trường nhập liệu
    _editCategoryNameController.text = category.categoryname;
    _editDescriptionController.text = category.description;
    showModalBottomSheet(
        context: context,
        isScrollControlled: true, // Chiều dài có thể được cuộn
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
        ),
        builder: (BuildContext context) {
          return Container(
            height: 500,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 18.0, top: 30.0, right: 18.0, bottom: 18.0),
              child: Column(
                children: [
                  Text(
                    'Cập nhật danh mục',
                    style: GoogleFonts.arsenal(
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                        color: primaryColors),
                  ),
                  SizedBox(height: 10),
                  LabeledTextField(
                      label: 'Tên danh mục mới',
                      controller: _editCategoryNameController),
                  LabeledTextField(
                      label: 'Mô tả danh mục',
                      controller: _editDescriptionController),
                  SizedBox(height: 10),
                  SizedBox(
                    height: 15.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          Category updateNewCategory = Category(
                            categoryid: category.categoryid,
                            categoryname: _editCategoryNameController.text,
                            description: _editDescriptionController.text,
                          );
                          if (updateNewCategory.categoryname.isEmpty ||
                              updateNewCategory.description.isEmpty) {
                            showCustomAlertDialog(context, 'Lỗi',
                                'Vui lòng nhập đầy đủ thông tin danh mục');
                            return;
                          }
                          ;
                          // print(updateNewCategory.categoryid);
                          // print(updateNewCategory.categoryname);
                          // Xử lý khi nhấn nút
                          await updateCategory(updateNewCategory);
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: green),
                        child: Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Icon(
                            //   Icons.cloud,
                            //   color: white,
                            // ),
                            // SizedBox(
                            //   width: 10,
                            // ),
                            Text(
                              'Lưu',
                              style: GoogleFonts.roboto(color: white),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  void performSearchCategory(String keyword) {
    setState(() {
      filteredCategories = categories
          .where((category) => category.categoryname
              .toLowerCase()
              .contains(keyword.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.only(
                left: 18.0, top: 18.0, right: 18.0, bottom: 10),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Sửa danh mục',
                    style: GoogleFonts.arsenal(
                      fontSize: 30,
                      color: brown,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 15),
                TextField(
                  controller: _textSearchCategoryController,
                  onChanged: (value) {
                    performSearchCategory(value);
                  },
                  decoration: InputDecoration(
                    hintText: 'Tìm kiếm danh mục',
                    contentPadding: EdgeInsets.symmetric(),
                    alignLabelWithHint: true,
                    filled: true,
                    fillColor: white,
                    prefixIcon: const Icon(
                      Icons.search,
                      size: 20,
                    ),
                    suffixIcon: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                            color: whiteGrey, shape: BoxShape.circle),
                        child: Center(
                          child: IconButton(
                            icon: const Icon(
                              Icons.clear,
                              size: 15,
                            ),
                            onPressed: () {
                              _textSearchCategoryController.clear();
                              performSearchCategory('');
                            },
                          ),
                        ),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(28.0),
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(28.0),
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Danh sách danh mục',
                    style: GoogleFonts.arsenal(
                      fontSize: 20,
                      color: brown,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 15),
              ],
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding:
                const EdgeInsets.only(left: 18.0, right: 18.0, bottom: 25.0),
            child: ListView.builder(
              physics: AlwaysScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: filteredCategories.length,
              itemBuilder: (context, index) {
                final category = filteredCategories[index];
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Icon(
                          Icons.category,
                          color: green,
                          size: 30,
                        ),
                      ),
                      Expanded(
                        flex: 6,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              category.categoryname,
                              style: GoogleFonts.arsenal(
                                fontSize: 18,
                                color: black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: IconButton(
                          icon: Icon(
                            Icons.edit,
                            color: blue,
                          ),
                          onPressed: () {
                            _showUpdateCategoryForm(context, category);
                          },
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 18.0, right: 18.0, bottom: 25.0),
          child: MyButton(
            text: 'Hoàn thành',
            onTap: () {
              Navigator.pushNamed(context, '/admin_page');
            },
            buttonColor: primaryColors,
          ),
        ),
      ],
    );
  }
}
