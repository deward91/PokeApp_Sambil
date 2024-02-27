import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/services.dart' show rootBundle;

//creamos clase para controlar scripts de login
class LoginController {

  //variables declaradas
  late BuildContext context;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  late ProgressDialog _progressDialog;
//cargamos el Loader o carga
  Future init(BuildContext context) async {
    this.context = context;
    _progressDialog = ProgressDialog(context: context);
  }
//metodo completo de inicio de sesion
  Future<void> login() async {
    _progressDialog.show(max: 100, msg: 'Cargando...');
//variables de controlador de texto
    String email = emailController.text;
    String password = passwordController.text;
//validamos datos de textos y boton para enviar mensaje o acceder
    if (!EmailValidator.validate(email)) {
      _progressDialog.close();
      _showAlert('Correo Inválido');
      return;
    }

    try {
      //ruta para validad usuarios
      String jsonString = await rootBundle.loadString('assets/json/users.json');
      var users = jsonDecode(jsonString)['users'];

      var user = users.firstWhere((user) => user['email'] == email, orElse: () => null);
//en caso de ser incorrecto
      if (user == null || user['password'] != password) {
        _progressDialog.close();
        _showAlert('Correo o contraseña incorrecta');
        return;
      }
//cargamos el loader
      _progressDialog.close();
      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(context, 'dashboard');
    } catch (e) {
      _progressDialog.close();
      _showAlert('Error al cargar los usuarios');
    }
  }
//Mostramos la alerta segun la accion
  void _showAlert(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Inicio de sesión'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

}
