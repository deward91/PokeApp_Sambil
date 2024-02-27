import 'package:flutter/material.dart';
import 'package:pokeapp_sambil/src/login/login_page.dart';
import 'package:pokeapp_sambil/src/dashboard/dashboard_page.dart';
import 'package:pokeapp_sambil/src/utils/my_colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget{
  const MyApp({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyAppState createState() => _MyAppState();
}

//contructor de mi app
class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, //quitamos etiqueta debug
      theme: ThemeData(
        primaryColor: MyColors.primaryColor, //color primario
        fontFamily: 'Flexo_Medium' //fuente principal
      ),
      title: 'PokeApp Sambil', //titulo de mi App
      initialRoute: 'login', //ruta inicial
      routes: {
        'login' : (BuildContext context) => const LoginPage(), //vista login
        'dashboard' : (BuildContext context) => const DashboardPage() //vista principal o dashboard
      },
    );
  }
}