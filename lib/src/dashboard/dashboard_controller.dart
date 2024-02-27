import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardController {
late BuildContext context;

Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('email');
}

  void init(BuildContext context) {}

  

}