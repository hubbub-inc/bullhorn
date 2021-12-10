import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:blips/providers/user_provider.dart';
import 'package:blips/providers/location_provider.dart';
import 'package:blips/pages/blip_view.dart';
import 'package:blips/services/shared_prefs.dart';
import 'package:blips/services/user_service.dart';
import 'package:blips/providers/messaging_provider.dart';
import 'package:blips/models/user_profile.dart';
import 'package:geocoding/geocoding.dart';


class UserDrawer extends StatefulWidget {
  late UserProvider userProvider;

  late LocationProvider locationProvider;
 UserProfile userProfile;
  UserDrawer({Key? key, required this.userProvider, required this.userProfile, required this.locationProvider}) : super(key: key);
  @override
  _UserDrawerState createState() => _UserDrawerState();
}
class _UserDrawerState extends State<UserDrawer> {
    bool _isLocationOn = true;
    bool _isNotificationsOn = true;
    TextEditingController _nameController = TextEditingController();
    TextEditingController _phoneController = TextEditingController();
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    late String valueName;
    late String valuePhone;


    @override
    initState() {
      super.initState();

      valueName = (widget.userProfile.name!="") ? widget.userProfile.name : "username";
      valuePhone = (widget.userProfile.phone!="") ? widget.userProfile.phone : "";
    }

    Future<void> _displayTextInputDialog(BuildContext context) async {
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
                title: Text('User info'),
                content:  Form(
                    key: _formKey,
                    child: Column(
                        children: <Widget>[

                          TextField(
                            onChanged: (value) {
                              setState(() {
                                valueName = value;
                              });
                            },
                            controller: _nameController,
                            decoration: const InputDecoration(hintText: "username"),
                          ),
                          TextField(
                            onChanged: (value) {
                              setState(() {
                                valuePhone = value;
                              });
                            },
                            controller: _phoneController,
                            decoration: const InputDecoration(hintText: "phone"),
                          ),])),
                actions: <Widget>[
                  FlatButton(
                    color: Colors.red,
                    textColor: Colors.white,
                    child: const Text('CANCEL'),
                    onPressed: () {
                      setState(() {
                        Navigator.pop(context);
                      });
                    },
                  ),
                  FlatButton(
                      color: Colors.green,
                      textColor: Colors.white,
                      child: const Text('OK'),
                      onPressed: () {

                        widget.userProvider.updateProfile(UserProfile(id: sharedPrefs.uid, name: valueName, phone: valuePhone));


                        Navigator.pop(context);
                      })
                ]);
          });
    }




  @override
  Widget build(BuildContext context) {
    // print(widget.locationProvider.placemark);
    final placemarks = widget.locationProvider.placemarks;
    String? usState = (placemarks.length>0) ? placemarks[0].administrativeArea : "";
    String? locality = (placemarks.isNotEmpty) ? placemarks[0].locality : "";
    MessagingProvider messagingProvider = Provider.of<MessagingProvider>(context);
    final notificationsList = widget.userProvider.notifications;

    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
        child: Scaffold(body: Column(
            children: <Widget>[




            SizedBox(height: 15),

    Container(
    width: 270,
    height: 150,
    decoration: const BoxDecoration(
    border: Border(
    top: BorderSide(color: Colors.red, width: 10, style: BorderStyle.solid),
    left: BorderSide(color: Colors.green, width: 10, style: BorderStyle.solid),
    ),
    ),
    child: Center(
             child: Column(children: <Widget>[
               Row(children: <Widget>[Text("USER INFO"), IconButton(icon: FaIcon(FontAwesomeIcons.userEdit),  onPressed: () { _displayTextInputDialog(context); })
    ]),
               Row(children: <Widget>[

                Text("username:  "),
                (widget.userProvider.profile.name=="") ? Text("n/a") : Text(widget.userProvider.profile.name),
              ]),
              Row(children: <Widget>[Text("phone:"),
                (widget.userProvider.profile.phone=="") ? Text("n/a") : Text(widget.userProvider.profile.phone),
              ]),
  Row(children: <Widget>[  Text(locality!),
    Text(usState!)])]))),


              Container(
                width: 270,
                height: 150,
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Colors.red, width: 10, style: BorderStyle.solid),
                    left: BorderSide(color: Colors.green, width: 10, style: BorderStyle.solid),
                  ),
                ),
                child: Center(
child:
              Column(children: <Widget>[
                Text("SETTINGS"),

                SwitchListTile(
                    title: Text('gps'),
                    secondary: Icon(Icons.gps_fixed),
                    value: _isLocationOn,
                    onChanged: (bool value) {
                      setState(() {
                        _isLocationOn = value;
                      });
                    }
                ),
                SwitchListTile(
                    title: Text('notifications'),
                    secondary: Icon(Icons.notifications),
                    value: _isNotificationsOn,
                    onChanged: (bool value) {
                      setState(() {
                        _isNotificationsOn = value;
                      });
                    }
                ),
            ]))),

              SizedBox(height: 25),

    Container(
    width: 270,
    height: 250,
    decoration: BoxDecoration(
    border: Border(
    top: BorderSide(color: Colors.red, width: 10, style: BorderStyle.solid),
    left: BorderSide(color: Colors.green, width: 10, style: BorderStyle.solid),
    ),
    ),
    child: Center(
    child: Column(
        children: <Widget>[

        Text("notifications"),
        SizedBox(height: 200,
            child: ListView.builder(
        itemCount: notificationsList.length,
        itemBuilder: (context, i) {
          return Text(notificationsList[i]);
        })),

    ])))])));
              //
              // SizedBox(height: 300, child: ListView.builder(
              //     itemCount: widget.userProvider.saved.length,
              //     itemBuilder: (context, i) {
              //       return Column(children: <Widget>[
              //         Text(widget.userProvider.saved[i].title),
              //
              //         SizedBox(height: 10),
              //         Row(children: <Widget>[
              //         RaisedButton(
              //             child: Text("more"),
              //             onPressed: () {
              //               Navigator.push(context, MaterialPageRoute(
              //                   builder: (context) =>
              //                       BlipView(blip: widget.userProvider.saved[i])));
              //             }
              //         ),
              //           RaisedButton(
              //               child: Text("subscribe"),
              //               onPressed: () {
              //
              //                 messagingProvider.subscribeToBlip(widget.userProvider.saved[i].id);
              //
              //               }
              //           ),
              //         SizedBox(width: 10),
              //         RaisedButton(
              //             child: Text("remove"),
              //             onPressed: () {
              //               widget.userProvider.deleteBlip(widget.userProvider.saved[i].id);
              //             }
              //         ),]),
              //       ]
              //       );
              //     }
              // )),=])));

  }
}
