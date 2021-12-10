import 'package:blips/services/user_service.dart';
import 'package:blips/models/user_profile.dart';
import 'package:blips/providers/messaging_provider.dart';
import 'package:blips/models/blip.dart';
import 'package:flutter/cupertino.dart';

class UserProvider with ChangeNotifier {

  late UserService userService;
  late MessagingProvider messagingProvider;

  UserProfile _profile = UserProfile(name: "", id: "", phone: "");
  List<Blip> _saved = <Blip>[];
  List<String> _notifications = [];
  // late List<Blip> _saved = <Blip>[];
  //

  UserProvider(this.userService) {
    fetchUserData();

  }



  UserProfile get profile => _profile;
  List<Blip> get saved => _saved;
  List<String> get notifications => [...{..._notifications}];

  void setProfile(UserProfile profile) {


    _profile = profile;
    notifyListeners();
  }

  void updateProfile(UserProfile profile) {
    userService.updateProfile(profile, this);
    fetchUserData();

  }

  void updateNotifications(String notification) {
    _notifications.add(notification);
    notifyListeners();
  }

  void setSaved(List<Blip> saved) {
    print("setting saved");
    _saved = saved;

    notifyListeners();
  }

  void saveBlip(Blip blip, MessagingProvider messagingProvider) {
    userService.saveBlip(blip, this);
    messagingProvider.subscribeToBlip(blip.id);
    fetchUserData();
  }

  void deleteBlip(String blipId, MessagingProvider messagingProvider) {
    userService.removeBlip(blipId, this);
    messagingProvider.unSubscribeToBlips(blipId);
    fetchUserData();
  }

  void subscribeToBlip(String blipId, MessagingProvider messagingProvider) {
    messagingProvider.subscribeToBlip(blipId);

  }

  void unsubscribeToBlip(String blipId, MessagingProvider messagingProvider) {
    messagingProvider.unSubscribeToBlips(blipId);
  }






  void fetchUserData() {

    userService.fetchProfile(this);
    userService.fetchSaved(this);

  }




}
