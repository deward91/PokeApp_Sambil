// ignore_for_file: library_private_types_in_public_api, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:pokeapp_sambil/src/login/login_controller.dart';
import 'package:pokeapp_sambil/src/utils/my_colors.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final LoginController _con = LoginController();
  bool _isPasswordVisible = false;
  
  get localStorage => null;
//inicializamos controladores
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _con.init(context);
    });
  }
//constructor visual de vista login
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Stack(
          children: [
            Positioned(
              top: -60,
              left: -100,
              child: _circleLogin(),
            ),
            Positioned(
              top: 60,
              left: 25,
              child: _textLogin(),
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  _imageBanner(),
                  _textFieldEmail(),
                  _textFieldPassword(),
                  _buttonLogin(),
                  _textforgotMyPassword(),
                  _textDontHaveAccount(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _textLogin() {
    return const Text( //texto de titulo
      'LOGIN',
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 22,
      ),
    );
  }

  Widget _circleLogin() { //detalle rojo
    return Container(
      width: 240,
      height: 230,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: MyColors.primaryColor,
      ),
    );
  }

  Widget _imageBanner() { //imagen logo
    return Container(
      margin: EdgeInsets.only(
        top: 80,
        bottom: MediaQuery.of(context).size.height * 0.1,
      ),
      child: Image.asset(
        'assets/img/pokeapplogo.png',
        width: 200,
        height: 200,
      ),
    );
  }

  Widget _textFieldEmail() { //campo correo
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 5),
      decoration: BoxDecoration(
        color: MyColors.primaryOpacitycolor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        controller: _con.emailController,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(15),
          hintStyle: TextStyle(
            color: MyColors.primaryDarkColor,
          ),
          prefixIcon: Icon(Icons.email, color: MyColors.primaryColor),
          labelText: 'Correo',
        ),
        textInputAction: TextInputAction.next,
      ),
    );
  }

  Widget _textFieldPassword() { //para contraseñas
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 5),
      decoration: BoxDecoration(
        color: MyColors.primaryOpacitycolor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        controller: _con.passwordController,
        decoration: InputDecoration(
          labelText: 'Password',
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(15),
          hintStyle: TextStyle(
            color: MyColors.primaryDarkColor,
          ),
          prefixIcon: Icon(
            Icons.lock,
            color: MyColors.primaryColor,
          ),
          suffixIcon: IconButton(
            icon: _isPasswordVisible
                ? const Icon(Icons.visibility_off)
                : const Icon(Icons.visibility),
            onPressed: () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
            },
          ),
        ),
        obscureText: !_isPasswordVisible,
        textInputAction: TextInputAction.done,
      ),
    );
  }

  Widget _buttonLogin() {
    return GestureDetector(
      onTap: _con.login,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
        child: ElevatedButton(
          onPressed: _con.login,
          style: ElevatedButton.styleFrom(
            backgroundColor: MyColors.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.symmetric(vertical: 15),
          ),
          child: const Text(
            'Ingresar',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }


  Widget _textDontHaveAccount() { //aun no tienes cuenta texto
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '¿No tienes cuenta aún?',
          style: TextStyle(
            color: MyColors.primaryColor,
          ),
        ),
        const SizedBox(width: 15),
        Text(
          'Regístrate',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: MyColors.primaryColor,
          ),
        ),
      ],
    );
  }

  Widget _textforgotMyPassword() { //texto olvide mi contraseña
    return Column(
      children: [
        Text(
          'Olvide mi contraseña',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: MyColors.primaryColor,
          ),
        ),
      ],
    );
  }
}
