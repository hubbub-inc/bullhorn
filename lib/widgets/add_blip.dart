import 'package:flutter/material.dart';
import 'package:blips/models/blip.dart';
import 'package:hashtagable/hashtagable.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:blips/widgets/icon_grid.dart';

import 'package:latlong2/latlong.dart';
import 'package:hashtagable/widgets/hashtag_text_field.dart';
import 'package:blips/models/user_location.dart';
import 'package:provider/provider.dart';
import 'package:blips/providers/photo_provider.dart';
import 'package:blips/providers/location_provider.dart';
import 'package:blips/providers/messaging_provider.dart';
import 'package:blips/providers/blips_provider.dart';
import 'package:blips/providers/user_provider.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:blips/pages/blip_view.dart';
import 'package:blips/constants.dart';


class AddItem extends StatefulWidget {
  LocationProvider locationProvider;
  BlipsProvider blipsProvider;
  AddItem(this.locationProvider, this.blipsProvider);

  @override
  _AddItemPageState createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItem> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _tagsController = TextEditingController();
  List<String> tags = <String>[];
  String valueTitle = "enter a title, user # prefix for tags";
  String valueTags = "";


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


  Widget _buildImage(PhotoProvider photoProvider) {
      if (photoProvider.image!=null) {
        final image = photoProvider.image;

        return Image.file(image!);
      } else {
        return Container(child: Text("none"));
      }

  }


  @override
  Widget build(BuildContext context) {
    String? usState = (widget.locationProvider.placemarks.length>0) ? widget.locationProvider.placemarks[0].administrativeArea : "";
    String? locality = (widget.locationProvider.placemarks.length>0) ? widget.locationProvider.placemarks[0].locality : "";
    double latitude = widget.locationProvider.userLocation.latitude!;
    double longitude = widget.locationProvider.userLocation.longitude!;
    final userProvider = Provider.of<UserProvider>(context);
    final photoProvider = Provider.of<PhotoProvider>(context);
    final messagingProvider = Provider.of<MessagingProvider>(context);
    List<Widget> outputs = photoProvider.outputs.map((output) => Text(output)).toList();
    return Scaffold(

        body: Column(children: <Widget>[

          Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Row(children: <Widget>[
                      Text(locality!),
                    Text(" "),
                    Text(usState!)]),

              TextField(
              onChanged: (value) {
            setState(() {
            valueTitle = value;
            });
            },
              controller: _titleController,
              decoration: InputDecoration(filled: true,
                fillColor: Colors.blueGrey, hintText: "give your post a title")),



                    // TextField(
                    //     onChanged: (value) {
                    //       setState(() {
                    //         valueTags = value;
                    //       });
                    //     },
                    //     controller: _tagsController,
                    //     decoration: InputDecoration(filled: true,
                    //         fillColor: Colors.blueGrey, hintText: "#awesome")),


                  SizedBox(height: 10),
                    (outputs.length>0) ? SizedBox(height: 50,
                       child: GridView.count(
                        crossAxisCount: 4,
                        crossAxisSpacing: 1.0,
                        mainAxisSpacing: 3.0,
                        children: outputs,
                    )) : SizedBox(height: 100),



            //         Row(children: <Widget>[
            //         IconButton(
            //           icon: Icon(Icons.camera_alt),
            //           onPressed: () {
            //
            //             photoProvider.fetchImage(ImageMode.Camera);
            //
            //           },
            //         ),
            //         IconButton(
            //           icon: Icon(Icons.photo),
            //           onPressed: () {
            //
            //             photoProvider.fetchImage(ImageMode.Gallery);
            //
            //           },
            //         ),
            //         IconButton(
            //           icon: Icon(Icons.share),
            //           onPressed: () {},
            //         ),
            // ])
                    (photoProvider.hasImage) ?  SizedBox(height: 300, child: _buildImage(photoProvider)) : const SizedBox(height: 200),
                Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[


                      IconButton(
                        icon: Icon(Icons.photo, size: 50),
                        onPressed: () {
                          photoProvider.fetchImage(ImageMode.Gallery);

                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.camera_alt, size: 50),
                        onPressed: () {
                          photoProvider.fetchImage(ImageMode.Camera);

                        },
                      ),

              ]),


              ]),
            ))]),


      floatingActionButton:
      Padding(
    padding: const EdgeInsets.only(bottom: 50.0),
    child: FloatingActionButton(

        onPressed: () {
          if (_titleController.text != "") {



              AwesomeDialog(
                context: context,
                dialogType: DialogType.INFO_REVERSED,
                borderSide: BorderSide(color: Colors.green, width: 2),
                width: 280,
                buttonsBorderRadius: BorderRadius.all(Radius.circular(2)),
                headerAnimationLoop: false,
                animType: AnimType.BOTTOMSLIDE,
                title: 'BROADCAST BLIP',
                desc: 'Are you sure?',
                showCloseIcon: true,
                btnCancelOnPress: () {},
                btnOkOnPress: () {
                  final snackBar = SnackBar(
                    content: const Text('blip addded successfully!'),
                  );
                  final List<String> hashTags = extractHashTags(
                      _tagsController.text);
                  widget.blipsProvider.addBlip(valueTitle, hashTags,
                      widget.locationProvider.userLocation, photoProvider);
                  _titleController.clear();
                  _tagsController.clear();
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                },
              )
                ..show();
          } else {
            final snackBar = SnackBar(
              content: const Text('please provide a title'),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        },

          // Add your onPressed code here!

        child: const Icon(Icons.check),
        backgroundColor: Colors.green,
      )),



    );
  }


}

class MapWidget extends StatelessWidget {
  double latitude;
  double longitude;

  MapWidget(this.latitude, this.longitude);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FlutterMap(
          options: MapOptions(
            center: LatLng(latitude, longitude),
            zoom: 13.0,
          ),
          layers: [
            TileLayerOptions(
              urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
              subdomains: ['a', 'b', 'c'],
              attributionBuilder: (_) {
                return Text("© OpenStreetMap contributors");
              },
            ),
            MarkerLayerOptions(
              markers: [
                Marker(
                  width: 80.0,
                  height: 80.0,
                  point: LatLng(latitude, longitude),
                  builder: (ctx) =>
                      Container(
                        child: FlutterLogo(),
                      ),
                ),
              ],
            ),
          ],
        ));
  }
}