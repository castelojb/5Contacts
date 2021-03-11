import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:five_contacts/widgets/main_screan.dart';
import 'package:shared_preferences/shared_preferences.dart';



class LoginScreen extends StatelessWidget {

  Duration get loginTime => Duration(milliseconds: 2250);


  Future<String> _authUser(LoginData data) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> users = prefs.getStringList('users') ?? [];
    List<String> passwords = prefs.getStringList('pass') ?? [];



    return Future.delayed(loginTime).then((_) async {

      if (!users.contains(data.name)) {
        return 'Usuário não existe';
      }

      int index = users.indexOf(data.name);


      if (passwords[index] != data.password) {
        return 'Senha incorreta';
      }

      await prefs.setString('current_user', data.name);

      return null;
    });
  }

  Future<String> _recoverPassword(String name) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> users = prefs.getStringList('users') ?? [];
    List<String> passwords = prefs.getStringList('pass') ?? [];


    return Future.delayed(loginTime).then((_) {

      if (!users.contains(name)) {

        return 'Usuário não existe!';

      }
      int index = users.indexOf(name);
      return passwords[index];

    });

  }

  Future<String> _createUser(LoginData data) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> users = prefs.getStringList('users') ?? [];
    List<String> passwords = prefs.getStringList('pass') ?? [];

    return Future.delayed(loginTime).then((_) async {

      if (users.contains(data.name)) {
        return 'Usuário ja existe!';
      }

      users.add(data.name);

      passwords.add(data.password);

      await prefs.setStringList('users', users);

      await prefs.setStringList('pass', passwords);

      await prefs.setString('current_user', data.name);

      return null;
    });

  }


  @override
  Widget build(BuildContext context) {
    return FlutterLogin(

      title: 'SOS Contatos',
      //logo: 'assets/images/ecorp.png',
      onLogin:  _authUser,
      onSignup: _createUser,
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => SOSscrean(),
        ));
      },
      onRecoverPassword: _recoverPassword,

      messages: LoginMessages(
        usernameHint: 'Usuário',
        passwordHint: 'Senha',
        confirmPasswordHint: 'Confirmar',
        loginButton: 'ENTRAR',
        signupButton: 'REGISTRAR',
        forgotPasswordButton: 'Memoria ta ruim?',
        recoverPasswordButton: 'SOCORRO',
        goBackButton: 'VOLTAR',
        confirmPasswordError: 'Não Achei!',
        recoverPasswordDescription:
        'Muita calma nessa hora champs',
        recoverPasswordSuccess: 'Senha recuperada com sucesso!',
      ),
    );
  }
}
