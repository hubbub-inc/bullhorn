import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:blips/providers/user_provider.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:blips/services/shared_prefs.dart';
import 'package:blips/providers/messaging_provider.dart';
import 'package:blips/models/blip.dart';
import 'package:blips/models/user_profile.dart';

class UserService {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Geoflutterfire geo = Geoflutterfire();




  Future<bool> fetchProfile(UserProvider userProvider) async {


    _firestore.collection("users").doc(sharedPrefs.uid)
        .get()
        .then((value) {
      print('FETCHED');
      print(value['id']);
      print("got");
      print(value);
      final profile = UserProfile.fromFirestore(value);
      print(profile.id);
      print("profiled");
      userProvider.setProfile(profile);
    });

    return true;
  }

  Future<void> fetchSaved(UserProvider userProvider) async {
    final snap = await _firestore.collection("savedRelation").doc(sharedPrefs.uid).collection("saved").get();
    print("fetching saved");
    final blips = snap.docs.map((i) => Blip.fromFirestore(i)).toList();
    print(blips.length.toString());
    userProvider.setSaved(blips);


  }

  Future<void> saveBlip(Blip blip, UserProvider userProvider) async {
    print("SAVING BLIP");
    GeoFirePoint point = geo.point(latitude: blip.latitude, longitude: blip.longitude);
    _firestore.collection("savedRelation").doc(sharedPrefs.uid).collection("saved").doc(blip.id).set({'title': blip.title, 'tags': blip.tags, 'position': point.data});

    fetchSaved(userProvider);
  }

  Future<void> removeBlip(String blipId, UserProvider userProvider) async {
    _firestore.collection("savedRelation").doc(sharedPrefs.uid).collection("saved").doc(blipId).delete();

    fetchSaved(userProvider);

  }

  Future<void> updateProfile(UserProfile userProfile, UserProvider userProvider) async {
    _firestore.collection("users").doc(userProfile.id).set(userProfile.toJson());
    fetchProfile(userProvider);
  }
}