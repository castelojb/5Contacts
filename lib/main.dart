import 'package:five_contacts/widgets/main_screan.dart';
import 'package:flutter/material.dart';
import 'package:five_contacts/widgets/log_in.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  bool auto_log = false;

  @override
  void initState() {
    super.initState();
    init_prefs();

  }

  init_prefs() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();

    bool is_auto_log_enabled = prefs.getBool('auto_log') ?? false;

    setState(() {
      auto_log = is_auto_log_enabled;
    });

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login Demo',
      theme: ThemeData(
        //primarySwatch: Colors.deepPurple,
        accentColor: Colors.blue,
        cursorColor: Colors.blue,
        textTheme: TextTheme(
          display2: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 45.0,
            color: Colors.white,
          ),
          button: TextStyle(
            fontFamily: 'OpenSans',
          ),
          subhead: TextStyle(fontFamily: 'NotoSans'),
          body1: TextStyle(fontFamily: 'NotoSans'),
        ),
      ),
      home: auto_log? SOSscrean() : LoginScreen(),
    );
  }
}