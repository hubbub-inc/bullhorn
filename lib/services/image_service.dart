import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:blips/providers/photo_provider.dart';
import 'package:blips/constants.dart';


class ImageService {
  final picker = ImagePicker();




  Future<void> getImageFromCamera(PhotoProvider photoProvider) async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);


    if (pickedFile!=null) {

      photoProvider.setImage(File(pickedFile.path));
    }




    }


  // gets image from gallery and runs detectObject
  Future<void> getImageFromGallery(PhotoProvider photoProvider) async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if(pickedFile != null) {
        photoProvider.setImage(File(pickedFile.path));
      }



    }


}