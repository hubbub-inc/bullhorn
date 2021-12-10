import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:blips/services/shared_prefs.dart';


import 'package:blips/providers/blips_provider.dart';
import 'package:blips/providers/user_provider.dart';
import 'package:blips/providers/chat_provider.dart';
import 'package:blips/services/user_service.dart';
import 'package:blips/providers/location_provider.dart';
import 'package:blips/widgets/user_drawer.dart';
import 'package:blips/pages/blips_view.dart';
import 'package:blips/widgets/chat_widget.dart';
import 'package:blips/widgets/add_blip.dart';
import 'package:blips/providers/messaging_provider.dart';
import 'package:blips/pages/blip_view.dart';
import 'package:blips/models/blip.dart';
import 'package:blips/models/user_profile.dart';
import 'package:blips/pages/hash_page.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  TextEditingController bullhornController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    BlipsProvider blipsProvider = Provider.of<BlipsProvider>(context);
    LocationProvider locationProvider = Provider.of<LocationProvider>(context);
    ChatProvider chatProvider = Provider.of<ChatProvider>(context);
    blipsProvider.initializeGeoStream(locationProvider.userLocation);
    UserProvider userProvider = Provider.of<UserProvider>(context);

    MessagingProvider messagingProvider = Provider.of<MessagingProvider>(context);
    messagingProvider.initializeMessaging(userProvider);
    UserProfile userProfile = userProvider.profile;





    return Scaffold(
        appBar: AppBar(elevation: 0),
    drawer: UserDrawer(
    userProfile: userProfile, userProvider: userProvider, locationProvider: locationProvider),
    body: DefaultTabController(
      length: 4,
      child: Scaffold(
      appBar: AppBar(bottom: TabBar(

          tabs: [

            Tab(icon: Icon(Icons.favorite)),
            Tab(icon: FaIcon(FontAwesomeIcons.bullhorn)),
            Tab(icon: Icon(Icons.search)),


          ])),

      body:

    SingleChildScrollView(child:
    Container(
    height: MediaQuery.of(context).size.height*0.8,
    child: TabBarView(
          children: [


            SizedBox(height: 900,child: SavedTab(userProvider.saved, userProvider, messagingProvider)),
            SizedBox(height: 900, child: AddItem(locationProvider, blipsProvider)),
            SizedBox(height: 900, child: BlipsView(blipsProvider: blipsProvider, userProvider: userProvider)),
   

          ],
        ))))));
  }
}


class SavedTab extends StatelessWidget {
  List<Blip> saved;
  UserProvider userProvider;
  MessagingProvider messagingProvider;

  SavedTab(this.saved, this.userProvider, this.messagingProvider);
  @override
  Widget build(BuildContext context) {
    print('USER ID IS');
    print(sharedPrefs.uid);
    return Scaffold(
      body:
      Column(
      children: <Widget>[
        Text("SAVED"),
        SizedBox(height: 400,
        child: ListView.builder(
          itemCount: saved.length,
          itemBuilder: (context, i) {
            return ListTile(title: Text(saved[i].title),
                trailing: IconButton(icon: FaIcon(FontAwesomeIcons.trash), onPressed: () {
                  userProvider.deleteBlip(userProvider.saved[i].id, messagingProvider);
                }),
                leading: IconButton(icon: Icon(Icons.info), onPressed: () {
                  Navigator.push(context,  MaterialPageRoute(builder: (context) => BlipView(blip: userProvider.saved[i])));
                })

            );
            return Text(userProvider.saved[i].title);
          }))
    ]));

  }
}


