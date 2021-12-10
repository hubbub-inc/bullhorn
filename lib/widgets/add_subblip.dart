import 'package:flutter/material.dart';
import 'package:blips/models/blip.dart';
import 'package:hashtagable/hashtagable.dart';
import 'package:hashtagable/widgets/hashtag_text_field.dart';
import 'package:provider/provider.dart';
import 'package:blips/providers/photo_provider.dart';
import 'package:blips/providers/location_provider.dart';
import 'package:blips/providers/blips_provider.dart';
import 'package:blips/constants.dart';
import 'package:blips/models/blip.dart';


class AddSubBlip extends StatefulWidget {
  Blip blip;
  AddSubBlip(this.blip);

  @override
  _AddSubBlipPageState createState() => _AddSubBlipPageState();
}

class _AddSubBlipPageState extends State<AddSubBlip> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _titleController = TextEditingController();

  late BlipsProvider _blipsProvider;
  late LocationProvider _locationProvider;
  String valueTitle = "enter a title, user # prefix for tags";


  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();


  }

  @override
  void dispose() {
    _titleController.dispose();

    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    _blipsProvider = Provider.of<BlipsProvider>(context);
    _locationProvider = Provider.of<LocationProvider>(context);

    String? usState = (_locationProvider.placemarks.length>0) ? _locationProvider.placemarks[0].administrativeArea : "";
    String? locality = (_locationProvider.placemarks.length>0) ? _locationProvider.placemarks[0].locality : "";
    final photoProvider = Provider.of<PhotoProvider>(context);

    return Scaffold(

      body:  Form(
              key: _formKey,
              child: Column(
                  children: <Widget>[

                    TextField(
                        onChanged: (value) {
                          setState(() {
                            valueTitle = value;
                          });
                        },
                        controller: _titleController,
                        decoration: InputDecoration(hintText: valueTitle)),

                    Text(locality!),
                    Text(usState!),
                    // IconButton(
                    //   icon: Icon(Icons.camera_alt),
                    //   onPressed: () {
                    //
                    //     photoProvider.fetchImage(ImageMode.Camera);
                    //
                    //   },
                    // ),
                    // IconButton(
                    //   icon: Icon(Icons.photo),
                    //   onPressed: () {
                    //
                    //     photoProvider.fetchImage(ImageMode.Gallery);
                    //
                    //   },
                    // ),
                    // IconButton(
                    //   icon: Icon(Icons.share),
                    //   onPressed: () {},
                    // ),
                    // IconButton(
                    //     icon:  Icon(Icons.notification_add),
                    //
                    //    onPressed: () {}
                    ])),
      floatingActionButton: FloatingActionButton(
        onPressed: () {

       _blipsProvider.addSubBlip(widget.blip,
           valueTitle, _locationProvider.userLocation, photoProvider);
       Navigator.pop(context);

        },
        child: const Icon(Icons.check),
      )
      ,
    );
  }


}