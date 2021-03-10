import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class ConstactsSearch extends StatefulWidget {
  @override
  _ConstactsSearchState createState() => _ConstactsSearchState();
}

class _ConstactsSearchState extends State<ConstactsSearch> {

  TextEditingController searchController = new TextEditingController();
  List<Contact> contacts = [];
  Map<String, Color> contactsColorMap = new Map();
  List<Contact> contactsFiltered = [];

  @override
  void initState() {
    super.initState();
    getPermissions();
  }

  getPermissions() async {
    if (await Permission.contacts.request().isGranted) {
      getAllContacts();
      //searchController.addListener(() {
      //  filterContacts();
      //});
    }
  }

  getAllContacts() async {
    List colors = [
      Colors.green,
      Colors.indigo,
      Colors.yellow,
      Colors.orange
    ];
    int colorIndex = 0;
    List<Contact> _contacts = (await ContactsService.getContacts()).toList();
    _contacts.forEach((contact) {
      Color baseColor = colors[colorIndex];
      contactsColorMap[contact.displayName] = baseColor;
      colorIndex++;
      if (colorIndex == colors.length) {
        colorIndex = 0;
      }
    });
    setState(() {
      contacts = _contacts;
    });
  }



  @override
  Widget build(BuildContext context) {

    bool isSearching = searchController.text.isNotEmpty;
    bool listItemsExist = (contactsFiltered.length > 0 || contacts.length > 0);

    return Scaffold(
      appBar: AppBar(title: Text('Contatos'),),
      body: Container(
        padding: EdgeInsets.all(20),
      child: Column(
        children: [
            Center(
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).primaryColor
                    )
                  ),
                  labelText: 'Busca',
                  prefixIcon: Icon(
                    Icons.search,
                    color: Theme.of(context).primaryColor,
                  ),
                ),

              ),
            ),
          listItemsExist == true ?
            Expanded(
                child: ListView.builder(

                    shrinkWrap: true,
                    itemCount: isSearching == true ? contactsFiltered.length : contacts.length,
                    itemBuilder: (context, index) {

                      Contact contact = isSearching == true ? contactsFiltered[index] : contacts[index];
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
                isSearching ?'No search results to show' : 'No contacts exist',
                style: Theme.of(context).textTheme.headline6
            ),
          ),

        ],
      ),
      )
    );
  }
}
