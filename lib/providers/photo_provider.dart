import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart';
import 'package:image_picker/image_picker.dart';
import 'package:blips/services/image_service.dart';
import 'package:blips/constants.dart';
import 'package:blips/services/shared_prefs.dart';
import 'package:tflite/tflite.dart';


class PhotoProvider with ChangeNotifier {
  late ImageService imageService;
  List _outputs = [];
  File? _imageFile;
  File? get image => _imageFile;
  bool get hasImage => (_imageFile!=null) ? true : false;
  List get outputs => _outputs;

  PhotoProvider(this.imageService) {
    loadModel();
  }

  Future<void> classifyImage() async {
    print('CLASSIFYING');
    print('CLASSIFYING');
    print('CLASSIFYING');
    print('CLASSIFYING');
    if (_imageFile!=null) {
      List? output = await Tflite.runModelOnImage(
        path: image?.path ?? "",
        numResults: 2,
        threshold: 0.5,
        imageMean: 127.5,
        imageStd: 127.5,
      );

      String _label = output![0]["label"];
      List _hashtagsResult = _hashtags["$_label"]!.toList();


      _outputs = _hashtagsResult;
      print(_outputs);
    }

  }

  loadModel() async {
    await Tflite.loadModel(
      model: "assets/model_unquant.tflite",
      labels: "assets/labels.txt",
    );
  }




  void setImage(File? imageFile) {
    _imageFile = imageFile;
    print('IMAGE HAS BEEN SET');
    print(_imageFile?.path);
    classifyImage();
    // uploadImage(imageFile);
    notifyListeners();


  }

  void fetchImage(ImageMode imageMode) {
    if (imageMode==ImageMode.Camera) {
      imageService.getImageFromCamera(this);


    } else {
            imageService.getImageFromGallery(this);
            classifyImage();
    }



  }

  Future<void> uploadImage(String subblipId, String blipId) async {
    if (image != null) {
      var stringElements = image?.path.split("/");
      if (stringElements != null) {
        int elementsLength = stringElements.length;
        String filename = stringElements[elementsLength - 1];


        String destination = blipId + "/" + subblipId;
        TaskSnapshot taskSnapshot = await FirebaseStorage.instance.ref(destination).putFile(image!);
        final String downloadUrl = await taskSnapshot.ref.getDownloadURL();
        await FirebaseFirestore.instance
            .collection("images")
            .doc(blipId)
            .collection("files")
            .doc(subblipId).set({"url": downloadUrl});
      }
    }
  }

  final _hashtags = {
    'Beauty': [
      '#beautylovers',
      '#intothegloss',
      '#makeuplovers',
      '#makeupflatlay',
      '#motd',
      '#makeupoftheday',
      '#makeuplife',
      '#igmakeup',
      '#instabeauty',
      '#beautyblogger'
    ],
    'Travel': [
      '#travelblogger',
      '#travellife',
      '#wanderlust',
      '#traveltheworld',
      '#igtravel',
      '#travelgram',
      '#instago',
      '#mytravelgram',
      '#worldcaptures',
      '#instavacation',
      '#vacaylife'
    ],
    'Food': [
      '#foodies',
      '#foodlovers',
      '#igfood',
      '#foodiesofinstagram',
      '#igfoodies',
      '#foodphotography',
      '#foodiesunite',
      '#foodislife'
    ],
    'Dogs': [
      '#dogsofinstagram',
      '#igdogs',
      '#doglover',
      '#instadog',
      '#petstagram',
      '#doggos',
      '#dogparent',
      '#dogs'
    ]
  };

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }



}