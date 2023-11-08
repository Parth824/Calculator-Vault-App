import 'dart:io';

import 'package:calculator_vault_app/size_config.dart';
import 'package:calculator_vault_app/src/functions/storage_permission_check.dart';
import 'package:calculator_vault_app/src/views/screens/options/video/video_picker_page.dart';
import 'package:calculator_vault_app/src/views/screens/options/video/videoview_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../../colors.dart';
import '../../../../models/gallery_model.dart';
import '../../../../models/restor_model.dart';
import '../../widgets/permission_denied_snackbar.dart';
import 'package:video_player/video_player.dart';

class VideoPage extends StatefulWidget {
  const VideoPage({super.key});

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  bool selectionEnabled = false;
  List<int> selectedImageKeys = [];
  List<Gallery> selectedImageOdeject = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getadata();
  }

  getadata() async {
    await Hive.openBox("restor");
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => onWillPop(),
      child: Scaffold(
        backgroundColor: firstColor,
        appBar: AppBar(
          backgroundColor: secondColor,
          centerTitle: true,
          actions: [actionButton()],
          title: Text(
            "Videos",
            style: TextStyle(fontFamily: "Gilroy"),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: fourthColor,
          onPressed: () async {
            storagePermissionCheck(
              onPermissionGranted: () async {
                Get.to(
                  () => VideoPickerPage(),
                  curve: Curves.easeInOut,
                  transition: Transition.fade,
                  duration: Duration(
                    milliseconds: 500,
                  ),
                );
              },
              onPermissionDenied: () => permissionDeniedSnackBar(context),
            );
          },
          child: Icon(
            Icons.add,
            color: firstColor,
            size: getProportionateScreenHeight(25),
          ),
        ),
        body: FutureBuilder<Box<Gallery>>(
          future: Hive.openBox('gallery'),
          builder: (context, galleryBoxSnapshot) {
            if (galleryBoxSnapshot.hasError) {
              return Center(
                child: Text(galleryBoxSnapshot.error.toString()),
              );
            }
            if (galleryBoxSnapshot.hasData && galleryBoxSnapshot.data != null) {
              return ValueListenableBuilder<Box<Gallery>>(
                valueListenable: galleryBoxSnapshot.data!.listenable(),
                builder: (context, galleryBox, child) {
                  final images = galleryBox.values
                      .where((element) => element.type == "video")
                      .toList();
                  if (images.isEmpty) {
                    return Center(
                      child: Text(
                        "Add Videos Here!",
                        style: TextStyle(
                            fontSize: getProportionateScreenHeight(16),
                            color: Colors.white,
                            fontFamily: "Gilroy"),
                      ),
                    );
                  }
                  print(selectedImageKeys);
                  print(selectedImageOdeject);
                  return GridView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: images.length,
                    itemBuilder: (context, index) {
                      return imageGrid(context, images[index],
                          selectedImageKeys.contains(images[index].key),images);
                    },
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 120,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                    ),
                  );
                },
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }

  Widget actionButton() {
    if (selectedImageKeys.isEmpty) {
      return Container();
    } else {
      return Row(
        children: [
          IconButton(
            onPressed: () async {
              var box = Hive.box<Gallery>('gallery');
              for (int i = 0; i < selectedImageOdeject.length; i++) {
                box.delete(selectedImageKeys[i]);
                final directory = await getApplicationDocumentsDirectory();
                final pathOfImage = await File(
                    '${directory.path}/${selectedImageOdeject[i].localPath.split('/').last}')
                    .create();
                await pathOfImage.writeAsBytes(selectedImageOdeject[i].bytes);
                await GallerySaver.saveVideo(pathOfImage.path);
              }
              selectionEnabled = false;
              selectedImageKeys.clear();
              selectedImageOdeject.clear();
              setState(() {

              });
            },
            icon: Icon(Icons.restore),
          ),
          IconButton(
            onPressed: () {
              final box = Hive.box<Gallery>('gallery');
              var box1 = Hive.box('restor');
              for (int i = 0; i < selectedImageOdeject.length; i++) {
                box.delete(selectedImageKeys[i]);
                box1.add(
                  Restor(
                    type: 'video',
                    thumbnailBytes: selectedImageOdeject[i].thumbnailBytes,
                    bytes: selectedImageOdeject[i].bytes,
                    dateTime: DateTime.now(),
                    localPath: selectedImageOdeject[i].localPath,
                  ),
                );
              }
              selectionEnabled = false;
              selectedImageKeys.clear();
              selectedImageOdeject.clear();
              setState(() {});
            },
            icon: const Icon(Icons.delete),
          ),
        ],
      );
    }
  }

  GestureDetector imageGrid(context, Gallery image, bool selected,List<Gallery> data) {
    return GestureDetector(
        onTap: () {
          if (selectionEnabled) {
            selected
                ? selectedImageKeys.remove(image.key)
                : selectedImageKeys.add(image.key);
            selected
                ? selectedImageOdeject.remove(image)
                : selectedImageOdeject.add(image);
            if (selected && selectedImageKeys.isEmpty) selectionEnabled = false;
            setState(() {});
            return;
          }
          Get.to(
            () => VideoViewPage(image: image,data: data),
            transition: Transition.fade,
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        },
        onLongPress: () {
          HapticFeedback.lightImpact();
          selectionEnabled = true;
          selectedImageKeys.add(image.key);
          selectedImageOdeject.add(image);
          setState(() {});
        },
        child: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            border: selected ? Border.all(width: 2, color: fourthColor) : null,
            image: DecorationImage(
              image: MemoryImage(image.thumbnailBytes),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(getProportionateScreenHeight(07),),
          ),
          child: selected
              ? const Align(
                  alignment: Alignment.topRight,
                  child: Icon(Icons.check_circle, color: fourthColor),
                )
              : null,
        ),);
  }

  Future<bool> onWillPop() async {
    if (selectionEnabled) {
      selectionEnabled = false;
      selectedImageKeys.clear();
      selectedImageOdeject.clear();
      setState(() {});
      return false;
    } else {
      return true;
    }
  }
}
