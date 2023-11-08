import 'package:calculator_vault_app/src/models/gallery_model.dart';
import 'package:get/get.dart';

class ImageViewController extends GetxController {
  RxList<Gallery> imageList = <Gallery>[].obs;
  RxInt currentIndex = 0.obs;
}