import 'package:flutter/cupertino.dart';
import 'package:blips/viewmodels/blipsview.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:async';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:blips/models/blip.dart';
import 'package:blips/models/user_location.dart';
import 'package:blips/providers/photo_provider.dart';
import 'package:blips/models/blip.dart';

class BlipsProvider with ChangeNotifier {

  late BlipsViewModel blipsViewModel;
  BlipsProvider(this.blipsViewModel);
   Geoflutterfire geo = Geoflutterfire();
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late Stream<List<DocumentSnapshot>> stream;
  final radius = BehaviorSubject<double>.seeded(1.0);
  late UserLocation currentLocation;
  late List<String> blipTags;


  final _blipsController = StreamController<
      List<Blip>>();

  final searchQuery = BehaviorSubject<String>.seeded("");



  StreamController<List<DocumentSnapshot>> docsController = StreamController<
      List<DocumentSnapshot>>();
  late StreamSubscription subscription;

  initializeGeoStream(UserLocation userLocation) {
    currentLocation = userLocation;



    GeoFirePoint center = geo.point(
        latitude: currentLocation.latitude!, longitude: currentLocation.longitude!);


    var collectionReference = _firestore.collection('locations');
    searchQuery.listen((query) {
     geo.collection(collectionRef: collectionReference)
          .within(
          center: center, radius: 1000000, field: 'position', strictMode: true)
          .listen((querySnap) {
        List<Blip> blips = querySnap.map((doc) => Blip.fromFirestore(doc))
            .toList();

        List<String> tags = [];
        blips.forEach((b) {
          b.tags.forEach((t) {
            if (!tags.contains(t)) {
              tags.add(t);
            }
          });

        });
        blipTags = tags;


        if (searchQuery.value=="") {
          blipsViewModel.setBlips(blips);
        } else {
          filterBlips(searchQuery.value, blips);
        }


        notifyListeners();
      });
    });
  }

  Future<List<SubBlip>> fetchSubblips(String blipId) {

    return _firestore.collection("subblipRelation").doc(blipId).collection("subblips").get().then((doc) =>
     doc.docs.map((doc) => SubBlip.fromFirestore(doc)).toList());


  }

  // List<SubBlip> fetchSubblips(String blipId) {
  //   print('FETCHING SUBBLIPS');
  //   print(blipId);
  //   List<SubBlip> subblips = <SubBlip>[];

  //   return subblips;
  // }



  void addSubBlip(Blip blipA, String title, UserLocation userLocation, PhotoProvider photoProvider) {
    GeoFirePoint geoFirePoint = geo.point(latitude: userLocation.latitude!, longitude: userLocation.longitude!);
    _firestore
      .collection("subblipRelation")
      .doc(blipA.id)
      .collection("subblips")
      .add({'title': title, 'position': geoFirePoint.data}).then((value) {
      if (photoProvider.hasImage) {
        photoProvider.uploadImage(value.id, blipA.id);
      }
      print('added ${geoFirePoint.hash} successfully');
    });
    notifyListeners();

  }

  void addBlip(String title, List<String> tags, UserLocation userLocation, PhotoProvider photoProvider) {
    GeoFirePoint geoFirePoint = geo.point(latitude: userLocation.latitude!, longitude: userLocation.longitude!);
    _firestore
        .collection('locations')
        .add({'title': title, 'tags': tags, 'position': geoFirePoint.data});
    notifyListeners();
  }
  filterBlips(String searchTag, List<Blip> blips) {
    List<Blip> filterList = <Blip>[];


     blips.forEach((i) {

       print(i.tags);
       if (i.tags.contains(searchTag)) {

         filterList.add(i);
       }
     });


      blipsViewModel.setBlips(filterList);




      notifyListeners();

  }

}


