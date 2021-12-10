import 'package:blips/models/blip.dart';

class BlipsViewModel {
  List<Blip> _blips = <Blip>[];

  setBlips(List<Blip> blips) {


    _blips = blips;
  }


  List<String> blipTags() {
    List<String> tags = [];
    _blips.forEach((b) {
      b.tags.forEach((t) {
        if (!tags.contains(t)) {
          tags.add(t);
        }
      });

    });

    return tags;
  }






  List<Blip> get blips => _blips;
}
