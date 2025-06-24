import 'package:flutter/material.dart';
import 'package:parking/presentation/screens/account/account_selection.dart';
import 'package:parking/presentation/screens/home/user_home.dart';


final Map<String, WidgetBuilder> Routes = {
  '/userPage': (context) => UserHomePage(),
  // '/ownerPage': (context) => OwnerPage(),
  // '/roleSelection': (context) => AccountSelection(roles: roles),
};