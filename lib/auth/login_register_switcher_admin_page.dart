import 'package:flutter/material.dart';
import 'package:highlandcoffeeapp/screens/admin/login_admin_with_identifier_and_password_page.dart';

class LoginRegisterSwitcherAdminPage extends StatefulWidget {
  const LoginRegisterSwitcherAdminPage({Key? key}) : super(key: key);

  @override
  _LoginRegisterSwitcherPageAdminState createState() =>
      _LoginRegisterSwitcherPageAdminState();
}

class _LoginRegisterSwitcherPageAdminState extends State<LoginRegisterSwitcherAdminPage> {
  bool showLoginPage = true;

  void togglePage() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: showLoginPage
            ? LoginAdminWithIdentifierAndPassWordPage(onTap: togglePage)
            : LoginAdminWithIdentifierAndPassWordPage(onTap: togglePage),
      ),
    );
  }
}
