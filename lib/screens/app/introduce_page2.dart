import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highlandcoffeeapp/widgets/button_next.dart';
import 'package:highlandcoffeeapp/themes/theme.dart';

class IntroducePage2 extends StatelessWidget {
  const IntroducePage2({super.key});
  final String hello = 'Xin chào!';
  final String imagePath = 'assets/images/coffee/phindi-hat-de-cuoi.jpg';
  final String title = 'Kết nối hài hòa giữ truyền thống với hiện đại';
  final String description =
      'Đến nay, Highlands Coffee® vẫn duy trì khâu phân loại cà phê bằng tay để trọn ra từng hạt cà phê chất lượng nhất, rang mới mỗi ngày và phục vụ quý khách với nụ cười rạng rỡ trên môi.';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: Padding(
        padding: const EdgeInsets.only(left: 18.0, top: 50.0, right: 18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              hello,
              style: GoogleFonts.arsenal(
                color: black,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            Image.asset(imagePath),
            Text(title,
                style: GoogleFonts.arsenal(
                    color: brown, fontSize: 25, fontStyle: FontStyle.italic)),
            const SizedBox(
              height: 10,
            ),
            Text(
              description,
              style: GoogleFonts.arsenal(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(
              height: 130,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ButtonNext(
                    text: 'Tiếp tục',
                    onTap: () {
                      Get.toNamed('/choose_login_type_page');
                    },
                    icon: Icons.trending_flat)
              ],
            )
          ],
        ),
      ),
    );
  }
}
