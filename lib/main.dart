import 'package:contacts_service/contacts_service.dart';
import 'package:five_contacts/widgets/contacts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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


  @override
  void initState() {
    super.initState();

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
  
  @override
  Widget build(BuildContext context) {

    callback(Contact contact){
      Navigator.pop(context);
      

      if (!check_matche_contacts(sos_contacts, contact)){
        

        setState(() {
          sos_contacts.add(contact);
        });

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
