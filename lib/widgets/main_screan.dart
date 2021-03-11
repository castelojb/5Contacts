import 'package:contacts_service/contacts_service.dart';
import 'package:five_contacts/widgets/contacts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';


class SOSscrean extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'S.O.S Contatos',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'SOS Contatos'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List<Contact> sos_contacts = [];

  String current_user;

  List<String> current_user_contacts;


  @override
  void initState() {
    super.initState();
    init_prefs();

  }


  init_prefs() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();

    String user = prefs.getString('current_user');

    List<String> contacts_names = prefs.getStringList(user) ?? [];
    print(user);
    print(contacts_names);

    List<Contact> _contacts = [];

    for(var i=0; i < contacts_names.length; i++){
      Map<String, dynamic> contact_json = jsonDecode(contacts_names[i]);


      _contacts.add(Contact(displayName: contact_json['name'], phones: [Item(label: "mobile", value: contact_json['phone'])]));


    }

    setState(() {
      current_user = user;
      sos_contacts = _contacts;
      current_user_contacts = contacts_names;
    });



  }



  Map color_map(List<Contact> list_) {

    Map<String, Color> contactsColorMap = new Map();

    List colors = [
      Colors.green,
      Colors.indigo,
      Colors.yellow,
      Colors.orange
    ];

    int colorIndex = 0;

    list_.forEach((contact) {

      Color baseColor = colors[colorIndex];
      contactsColorMap[contact.displayName] = baseColor;
      colorIndex++;

      if (colorIndex == colors.length) {
        colorIndex = 0;
      }
    });

    return contactsColorMap;

  }

  bool check_matche_contacts(List<Contact> constacts, Contact target){

    for (var i = 0; i < constacts.length; i++){

      if (constacts[i].displayName == target.displayName){
        return true;
      }

    }

    return false;

  }

  make_call(Contact contact) async {

    var phone_number = contact.phones.length > 0 ? contact.phones.elementAt(0).value : '';

    String url = 'tel: $phone_number';

    if (phone_number != '' && await canLaunch(url)){

      await launch(url);

    }else{
      CupertinoAlertDialog(
        title: Text('Contato não possui número cadastrado'),
      );

    }


  }

  @override
  Widget build(BuildContext context) {

    callback(Contact contact) async {
      Navigator.pop(context);


      if (!check_matche_contacts(sos_contacts, contact)){


        Map<String, String> cache_contact = Map();

        cache_contact['name'] = contact.displayName == null? '' : contact.displayName;
        cache_contact['phone'] =  contact.phones.length > 0 ? contact.phones.elementAt(0).value : '';

        setState(() {
          sos_contacts.add(contact);
          current_user_contacts.add(jsonEncode(cache_contact));

        });

        SharedPreferences prefs = await SharedPreferences.getInstance();

        await prefs.setStringList(current_user, current_user_contacts);


      }

    }

    return Scaffold(
      appBar: AppBar(

        title: Text(widget.title),
      ),
      body: Center(

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            sos_contacts.length > 0 ?
            Expanded(
              child: ListView.builder(

                  shrinkWrap: true,
                  itemCount: sos_contacts.length,
                  itemBuilder: (context, index) {

                    Contact contact = sos_contacts[index];


                    var contactsColorMap = color_map(sos_contacts);

                    var baseColor = contactsColorMap[contact.displayName] as dynamic;

                    Color color1 = baseColor[800];
                    Color color2 = baseColor[400];

                    return ListTile(
                      onTap: (){
                        make_call(contact);
                      },
                      title: Text(contact.displayName == null? '' : contact.displayName),
                      subtitle: Text(
                          contact.phones.length > 0 ? contact.phones.elementAt(0).value : ''
                      ),
                      leading: (contact.avatar != null && contact.avatar.length > 0) ?
                      CircleAvatar(
                        backgroundImage: MemoryImage(contact.avatar),
                      ) :
                      Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                  colors: [
                                    color1,
                                    color2,
                                  ],
                                  begin: Alignment.bottomLeft,
                                  end: Alignment.topRight
                              )
                          ),
                          child: CircleAvatar(
                              child: Text(
                                  contact.initials(),
                                  style: TextStyle(
                                      color: Colors.white
                                  )
                              ),
                              backgroundColor: Colors.transparent
                          )
                      ),
                    );
                  }
              ),
            ) : Container(
              padding: EdgeInsets.all(20),
              child: Text(
                  'Não tem ninguem para chamar! CORRE',
                  style: Theme.of(context).textTheme.headline6
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ConstactsSearch(callback)),
          );
        },
        tooltip: 'Add',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
