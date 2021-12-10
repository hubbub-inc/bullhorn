import 'package:flutter/material.dart';
import 'package:blips/models/blip.dart';
import 'package:blips/providers/chat_provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' hide Marker, LatLng;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:blips/widgets/chat_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:blips/widgets/fancy_card.dart';
import 'package:latlong2/latlong.dart';
import 'package:blips/widgets/card_carousel.dart';
import 'package:blips/widgets/sub_header.dart';
import 'package:blips/constants.dart';
import 'package:blips/providers/location_provider.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:blips/providers/photo_provider.dart';
import 'package:blips/providers/blips_provider.dart';
import 'package:blips/providers/user_provider.dart';
import 'package:blips/widgets/add_subblip.dart';
import 'package:blips/widgets/icon_grid.dart';



class BlipView extends StatefulWidget {
final Blip blip;
const BlipView({required this.blip});
@override

BlipViewState createState() => BlipViewState();

}

class BlipViewState extends State<BlipView> {

  TextEditingController _titleController = TextEditingController();
  String valueTitle = "";
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String blipDisplay = "home";
  Image currentImage = Image.asset("assets/pluto-welcome.png");
  List<Image> fetchedImages = [];



  List<Widget> displayCards = [
    FancyCard(
      image: Image.asset("assets/pluto-done.png"),
      title: "swipe up on me to scroll through feed for",
    ),



    FancyCard(
      image: Image.asset("assets/pluto-sign-up.png"),
      title: "swipe below to chat with other users",
    ),

    FancyCard(
      image: Image.asset("assets/pluto-welcome.png"),
      title: "use the bullhorn to reach your audience",
    ),
    FancyCard(
      image: Image.asset("assets/pluto-waiting.png"),
      title: "forthcoming: subscribe to notifications for special promotions",
    ),
  ];

  List<String> reportList = [
    "Social",
    "Freebies",
    "Food",
  ];

  List<String> selectedReportList = <String>[];
  List<Image> images = <Image>[];

  Widget titleOrImage() {

      return FancyCard(
        image: currentImage,
        title: blipDisplay,
      );

  }

  Future<void> setDisplay (String title, String subblipId) async {
    blipDisplay = title;
    _firestore.collection("images").doc(widget.blip.id).collection("files").doc(
        subblipId).get()
        .then((doc) {
      if (doc.exists) {
        currentImage =
            Image.network(doc.data()!['url']);
      }
    });
    _selectedIndex = 0;
  }

  Widget _buildImage(PhotoProvider photoProvider) {
    if (photoProvider.image!=null) {
      final image = photoProvider.image;

      return Image.file(image!, height: 150, width: 150);
    } else {
      return SizedBox(height: 100, width: 150);
    }

  }

  Future<void> fetchImages(String blipId) async {
    _firestore.collection("images").doc(blipId).collection("files")
        .snapshots()
        .listen((snap) {
          print('FETCHING IMAGE URLS');
      List<Image> _images = snap.docs.map((doc) =>
          Image.network(doc.data()['url'])).toList();
      images = _images;
      print('no of images is:');
      print(images.length);
          for (var image in images) {
            print('ADDING CARD');
            FancyCard card =  FancyCard(
              image: image,
              title: "CARD ADDED BY USER",
            );
            displayCards.insert(0, card);
          }

    });
  }

   @override
   initState() {
     super.initState();
     fetchImages(widget.blip.id);





   }



  bool isAdding = false;
  Widget renderBlip(Blip blip, LocationProvider locationProvider, BlipsProvider blipsProvider, PhotoProvider photoProvider) {
    String? usState = (locationProvider.placemarks.length>0) ? locationProvider.placemarks[0].administrativeArea : "";
    String? locality = (locationProvider.placemarks.length>0) ? locationProvider.placemarks[0].locality : "";
    List<String> blipTags = blip.tags.cast<String>();
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(children: <Widget>[Text(locality!), Text(" "), Text(usState!)]),

          TextField(
              onChanged: (value) {
                setState(() {
                  valueTitle = value;
                });
              },
              controller: _titleController,
              decoration: InputDecoration(filled: true,
                  fillColor: Colors.blueGrey, hintText: "give your post a title")),
          SizedBox(height: 175, child: IconGrid()),
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

    Text("submit  "), Ink(
     decoration: ShapeDecoration(
     color: Colors.green,
     shape: CircleBorder(),
     ),
           child:
           IconButton(
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
             blipsProvider.addSubBlip(widget.blip,
                 valueTitle, locationProvider.userLocation, photoProvider);
             _titleController.clear();
             _selectedIndex = 0;
             ScaffoldMessenger.of(context).showSnackBar(snackBar);
           })
         ..show();
     } else {
               final snackBar = SnackBar(
               content: const Text('please provide a title'),
               );
               ScaffoldMessenger.of(context).showSnackBar(snackBar);
               }





           },
             icon: Icon(Icons.check),
           )),Text("  ")])
    ]);


          // (blip.tags.length>0) ?  MultiSelectChip(
          //   blipTags,
          //   onSelectionChanged: (selectedList) {
          //     setState(() {
          //       selectedReportList = selectedList;
          //     });
          //   },
          // ) : Container(),





  }
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    ChatProvider chatProvider = Provider.of<ChatProvider>(context);
    LocationProvider  locationProvider = Provider.of<LocationProvider>(context);
    BlipsProvider blipsProvider = Provider.of<BlipsProvider>(context);
    UserProvider userProvider = Provider.of<UserProvider>(context);
    final photoProvider = Provider.of<PhotoProvider>(context);
    return Scaffold(
        appBar: AppBar(),
        body: CustomScrollView(
            slivers: <Widget>[

              SliverToBoxAdapter(
                child: SizedBox(height: 500,
                child: Row(children: <Widget>[ NavigationRail(
                 groupAlignment: 0.5,
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: (int index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  labelType: NavigationRailLabelType.selected,
                  destinations: const <NavigationRailDestination>[
                    NavigationRailDestination(
                      icon:  FaIcon(FontAwesomeIcons.broadcastTower, size: 40),
                      selectedIcon: FaIcon(FontAwesomeIcons.broadcastTower, size: 50),
                      label: Text('Newsfeed'),
                    ),

                    NavigationRailDestination(
                      icon: Icon(Icons.add, size: 40),
                      selectedIcon: Icon(Icons.add, size: 50),
                      label: Text('add'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.chat, size: 40),
                      selectedIcon: Icon(Icons.chat, size: 50),
                      label: Text('chat'),
                    ),
                  ],
                ),
                  const VerticalDivider(thickness: 1, width: 1),
                  // This is the main content.

            Expanded(
                      child: SizedBox(height: 400,
                      child: (_selectedIndex==0) ?
                      // StackedCardCarousel(items: displayCards)
                      titleOrImage()
                          : (_selectedIndex==1) ? renderBlip(widget.blip, locationProvider, blipsProvider, photoProvider) : ChatWidget(chatProvider: chatProvider, chatId: widget.blip.id),
                    ))
                  ]),
              )),
              // SliverSubHeader(
              //   'Chat',
              //   AppColors.indigo,
              // ),
              //

              SliverFillRemaining(
                fillOverscroll: true,
                child: MapWidget(blip: widget.blip,
    setDisplay: (String title, String subblipId ) => setDisplay(title, subblipId),
    setAdd: () { setState(() { _selectedIndex = 1; }); },)
              )
    ]));

  }
}


class MapWidget extends StatefulWidget {
  Blip blip;
  final Function(String, String) setDisplay;
  final Function() setAdd;
  MapWidget({required this.blip, required this.setDisplay, required this.setAdd});
  @override
  _MapWidgetState createState() => _MapWidgetState();
}


class _MapWidgetState extends State<MapWidget> {
  List<SubBlip> subblip = [];


  @override
  Widget build(BuildContext context) {
    final blipsProvider = Provider.of<BlipsProvider>(context);



    return FutureBuilder<List<SubBlip>>(
    future: blipsProvider.fetchSubblips(widget.blip.id),
    builder: (context, snapshot) {
    if (!snapshot.hasData) {
      return CircularProgressIndicator();
    } else {

      List<Marker>? markers = snapshot.data?.map((subblip) =>   Marker(
        width: 80.0,
        height: 80.0,
        point: LatLng(subblip.latitude, subblip.longitude),
        builder: (ctx) => GestureDetector(
          onTap: () {

            widget.setDisplay(subblip.title, subblip.id);




          },


          child: Icon(
          Icons.circle,
          color: Colors.red,
          size: 30.0,
        ))))
          .toList();

  void _handleTap(TapPosition, LatLng latlng) {
  widget.setAdd();
  }



    return Scaffold(
    body: Stack(
          children: <Widget>[
            FlutterMap(
    options: MapOptions(
    // onTap: _handleTap,
    center: LatLng(widget.blip.latitude, widget.blip.longitude),
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
    markers: markers?? [],
    )])]));
    }});

}}




  class MultiSelectChip extends StatefulWidget {
  final List<String> reportList;
  final Function(List<String>) onSelectionChanged;

  MultiSelectChip(this.reportList, {required this.onSelectionChanged});

  @override
  _MultiSelectChipState createState() => _MultiSelectChipState();
  }

  class _MultiSelectChipState extends State<MultiSelectChip> {
  // String selectedChoice = "";
  List<String> selectedChoices = <String>[];

  _buildChoiceList() {
  List<Widget> choices = <Widget>[];

  widget.reportList.forEach((item) {
  choices.add(Container(
  padding: const EdgeInsets.all(2.0),
  child: ChoiceChip(
  label: Text(item),
  selected: selectedChoices.contains(item),
  onSelected: (selected) {
  setState(() {
  selectedChoices.contains(item)
  ? selectedChoices.remove(item)
      : selectedChoices.add(item);
  widget.onSelectionChanged(selectedChoices);
  });
  },
  ),
  ));
  });

  return choices;
  }

  @override
  Widget build(BuildContext context) {
  return Wrap(
  children: _buildChoiceList(),
  );
  }
  }


class CustomPopup extends StatefulWidget {

  CustomPopup({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return CustomPopupState();
  }
}
class CustomPopupState extends State<CustomPopup> {
  var heading = '\$2300 per month';
  var subheading = '2 bed, 1 bath, 1300 sqft';
  var cardImage = NetworkImage(
      'https://source.unsplash.com/random/800x600?house');
  var supportingText =
      'Beautiful home to rent, recently refurbished with modern appliances...';
  @override
  Widget build(BuildContext context) {
    return Container(height: 400,
    width: 200,
    color: Colors.yellow);
  // return Card(
  // elevation: 4.0,
  // child: Column(
  // children: [
  // ListTile(
  // title: Text(heading),
  // subtitle: Text(subheading),
  // trailing: Icon(Icons.favorite_outline),
  // ),
  // // Container(
  // // height: 200.0,
  // // child: Ink.image(
  // // image: cardImage,
  // // fit: BoxFit.cover,
  // // ),
  // // ),
  // // Container(
  // // padding: EdgeInsets.all(16.0),
  // // alignment: Alignment.centerLeft,
  // // child: Text(supportingText),
  // // ),
  // ButtonBar(
  // children: [
  // TextButton(
  // child: const Text('CONTACT AGENT'),
  // onPressed: () {/* ... */},
  // ),
  // TextButton(
  // child: const Text('LEARN MORE'),
  // onPressed: () {/* ... */},
  // )
  // ],
  // )
  // ],
  // ));
}}