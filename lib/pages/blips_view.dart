import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:blips/providers/blips_provider.dart';
import 'package:provider/provider.dart';
import 'package:blips/services/user_service.dart';
import 'package:blips/providers/location_provider.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:blips/providers/user_provider.dart';
import 'package:blips/providers/messaging_provider.dart';
import 'package:blips/models/blip.dart';
import 'package:blips/pages/blip_view.dart';


class BlipsView extends StatefulWidget {
  final BlipsProvider blipsProvider;
  final UserProvider userProvider;
  const BlipsView({required this.blipsProvider, required this.userProvider});
  @override
  BlipsViewState createState() => BlipsViewState();
}



class BlipTile extends StatelessWidget {
  Blip blip;


  UserProvider userProvider;
  VoidCallback onTap;
  BlipTile(this.blip, this.userProvider, this.onTap);
  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: IconButton(icon: Icon(Icons.info),  onPressed: onTap,),
        title:  Text(blip.title),

        );

  }
}


class BlipsViewState extends State<BlipsView>
    with SingleTickerProviderStateMixin {





   String searchTag = "";

  @override
  void initState() {
    super.initState();



  }

  @override
  void dispose() {
    super.dispose();

  }
  List list = [
    "Flutter",
    "Angular",
    "Node js",
    "failing",
  ];

   List<String> reportList = [
     "Social",
     "Freebies",
     "Food",

   ];

     void showInfoSheet(Blip blip, UserProvider userProvider, MessagingProvider messagingProvider) => showModalBottomSheet(
        context: context,
        builder: (context) {
          List<String> blipTags = blip.tags.cast<String>();
          return ListView(
            children: <Widget>[
              SizedBox(height: 15),
             Card(child:  ListTile(

                title: new Text("      " + blip.title),
                onTap: () {
                  Navigator.pop(context);
                },
              )),
              SizedBox(height: 15),
              Card(child:  ListTile(
                leading: FaIcon(FontAwesomeIcons.infoCircle),
                title: new Text("TODO: summary/description of the thread"),

              )),
              SizedBox(height: 15),
             Card(child:  ListTile(

                title: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child:  Row(
                        children: <Widget>[
                         Column(children: <Widget>[FaIcon(FontAwesomeIcons.hashtag),
                            SizedBox(height: 15),


                            FaIcon(FontAwesomeIcons.icons),]),
                          SizedBox(width: 25),
                          (blip.tags.length>0) ?  MultiSelectChip(
                            blipTags,
                            onSelectionChanged: (selectedList) {
                              setState(() {
                                print(selectedList);
                              });
                            },
                          ) : Container()])),
                onTap: () {

                },
              )),
              SizedBox(height: 15),


          Card(child: ListTile(
            title: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, crossAxisAlignment: CrossAxisAlignment.end, children: <Widget>[Text("back"), IconButton(icon: Icon(Icons.cancel), onPressed: () { Navigator.pop(context); }),
                  Text("more"),  IconButton(icon: Icon(Icons.info), onPressed: () {   Navigator.push(context, MaterialPageRoute(
                      builder: (context) =>
                          BlipView(blip: blip))); }),
                  Text("save"),  IconButton(icon: Icon(Icons.favorite), onPressed: () { widget.userProvider.saveBlip(blip,  messagingProvider);  }),
                ])),
          )),


              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Row(children: <Widget>[SizedBox(height: 20)])),




            ]
          );
        });


  @override
  Widget build(BuildContext context) {
    final blips = widget.blipsProvider.blipsViewModel.blips;
    final locationProvider = Provider.of<LocationProvider>(context);
    final messagingProvider = Provider.of<MessagingProvider>(context);
    list = widget.blipsProvider.blipTags;

    return Scaffold(

      body:

      Column(
        crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[

        GFSearchBar(
            searchList: list,
            searchQueryBuilder: (query, list) => list
                .where((item) {
              return item!.toString().toLowerCase().contains(query.toLowerCase());
            })
                .toList(),

            overlaySearchListItemBuilder: (dynamic item) => Container(
              padding: const EdgeInsets.all(8),
              child: Text(
                item,
                style: const TextStyle(fontSize: 18),
              ),
            ),
            onItemSelected: (dynamic item) {

                searchTag = item;
                widget.blipsProvider.searchQuery.add(item);


            }),
        SizedBox(height: 300, child: ListView.builder(
            itemCount: blips.length,
            itemBuilder: (context, i) {





              return BlipTile(
                  blips[i], widget.userProvider, () => showInfoSheet(blips[i], widget.userProvider, messagingProvider));
            })),
       ]),
    );
  }

  Widget _tagIcon() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.local_offer_outlined,
          color: Colors.deepOrangeAccent,
          size: 25.0,
        ),

      ],
    );
  }
}




class TagModel {
  String id;
  String title;

  TagModel({
    required this.id,
    required this.title,
  });
}


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
