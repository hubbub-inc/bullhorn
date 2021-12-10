import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

class Blip {
  String id;
  String title;
  List<dynamic> tags;
  double latitude;
  double longitude;

  Blip(this.id, this.title, this.tags, this.latitude, this.longitude);


  factory Blip.fromFirestore(DocumentSnapshot doc) {
    final pos = doc['position']['geopoint'];

    return Blip(
        doc.id,
        doc['title'] ?? '',
        doc['tags'] ?? [],
        pos.latitude ?? 0.0,
        pos.longitude ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() => { 'title': title,  'tags': tags, 'id': id, 'latitude': latitude, 'longitude': longitude};

}

class SubBlip {
  String id;
  String title;

  double latitude;
  double longitude;

  SubBlip(this.id, this.title, this.latitude, this.longitude);


  factory SubBlip.fromFirestore(DocumentSnapshot doc) {
    final pos = doc['position']['geopoint'];

    return SubBlip(
      doc.id,
      doc['title'] ?? '',
      pos.latitude ?? 0.0,
      pos.longitude ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() => { 'title': title,  'id': id, 'latitude': latitude, 'longitude': longitude};

}

