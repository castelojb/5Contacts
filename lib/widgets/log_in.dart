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

    Future<String> _recoverPassword(String name) async {

      SharedPreferences prefs = await SharedPreferences.getInstance();

      List<String> users = prefs.getStringList('users') ?? [];
      List<String> passwords = prefs.getStringList('pass') ?? [];


      return Future.delayed(loginTime).then((_)  {

        if (!users.contains(name)) {

          return 'Usuário não existe!';

        }
        int index = users.indexOf(name);
        String password_user =  passwords[index];



        showDialog(context: context,
            builder: (_) => AlertDialog(
              title: Text('Senha'),
              content: Text('Sua senha é: $password_user'),
              elevation: 24.0,

            )
        );

        return null;

      });

    }
    return FlutterLogin(

      title: 'SOS Contatos',
      onLogin:  _authUser,
      onSignup: _createUser,
      onSubmitAnimationCompleted: () async {
        await showDialog(context: context,
            builder: (_) => AlertDialog(
              title: Text('Bem vindo(a)!'),
              content: Text('Posso salvar essa conta como login automático?'),
              actions: [
                TextButton(
                    onPressed: () async {
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      await prefs.setBool('auto_log', true);
                      Navigator.of(context, rootNavigator: true).pop('dialog');
                    },
                    child: Text('Claro!')
                ),
                TextButton(
                    onPressed: () async {
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      await prefs.setBool('auto_log', false);
                      Navigator.of(context, rootNavigator: true).pop('dialog');
                    },
                    child: Text('Estou só de passagem')
                ),
              ],
              elevation: 24.0,

            )
        );
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => SOSscrean()

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
        recoverPasswordIntro: 'Quem é você?',
        recoverPasswordDescription:
        'Preste atenção na discreta mensagem com sua senha...',
        recoverPasswordSuccess: 'Senha recuperada com sucesso!',
      ),
    );

  }
}
