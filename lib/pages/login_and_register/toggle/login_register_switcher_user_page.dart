import 'package:flutter/material.dart';
import 'package:highlandcoffeeapp/screens/login_customer_with_identifier_page.dart';
import 'package:highlandcoffeeapp/screens/register_customer_with_identifier_page.dart.dart';

class LoginRegisterSwitcherUserPage extends StatefulWidget {
  const LoginRegisterSwitcherUserPage({super.key});

  @override
  State<LoginRegisterSwitcherUserPage> createState() => _LoginRegisterSwitcherUserPageState();
}

class _LoginRegisterSwitcherUserPageState extends State<LoginRegisterSwitcherUserPage> {
  bool showloginPage  = true;

  //function toggle
  void togglePage(){
    setState(() {
      showloginPage = !showloginPage;
    });
  }
  @override
  Widget build(BuildContext context) {
    if(showloginPage){
      return LoginCustomerWithIdentifierPage(onTap: togglePage);
    }else{
      return RegisterCustomerWithIdentifierPage(onTap: togglePage,);
    }
  }
}