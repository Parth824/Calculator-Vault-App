import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../../colors.dart';
import '../../../../../size_config.dart';
import '../../../../models/restor_model.dart';
import 'image_picker_page.dart';
import '../../widgets/permission_denied_snackbar.dart';
import '../../../../functions/storage_permission_check.dart';
import '../../../../models/gallery_model.dart';
import 'imageview_page.dart';
import 'package:gallery_saver/gallery_saver.dart';

class ImagePage extends StatefulWidget {
  const ImagePage({super.key});

  @override
  State<ImagePage> createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage> {
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
          actions: [
            actionButton(),
          ],
          title: Text(
            "Images",
            style: TextStyle(fontFamily: "Gilroy"),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: fourthColor,
          onPressed: () async {
            storagePermissionCheck(
              onPermissionGranted: () async {
                Get.to(
                  () => ImagePickerPage(),
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
                      .where((element) => element.type == "image")
                      .toList();
                  if (images.isEmpty) {
                    return Center(
                      child: Text(
                        "Add Images Here!",
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
        // GridView.builder(
        //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        //       crossAxisCount: 4, crossAxisSpacing: 5, mainAxisSpacing: 5),
        //   padding: EdgeInsets.only(
        //       top: getProportionateScreenHeight(10),
        //       right: getProportionateScreenHeight(10),
        //       left: getProportionateScreenHeight(10)),
        //   physics: BouncingScrollPhysics(),
        //   itemCount: 14,
        //   itemBuilder: (context, index) {
        //     return Container(
        //       decoration: BoxDecoration(
        //         color: Colors.white,
        //         borderRadius: BorderRadius.circular(
        //           getProportionateScreenHeight(5),
        //         ),
        //       ),
        //     );
        //   },
        // ),
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
                print("${selectedImageOdeject[i].dateTime}");
                var k = selectedImageOdeject[i].localPath.split("/");
                String join = "";
                for (int j = 0; j < k.length - 1; j++) {
                  join = join + k[j] + "/";
                }
                print(join);
                final pathOfImage = await File(
                    "$join${selectedImageOdeject[i].localPath.split('/').last}");
                await pathOfImage.writeAsBytes(selectedImageOdeject[i].bytes);
                await pathOfImage
                    .setLastModified(selectedImageOdeject[i].dateTime);
                await pathOfImage
                    .setLastAccessed(selectedImageOdeject[i].dateTime);
                (st==1)
                    ? null
                    : await GallerySaver.saveImage(pathOfImage.path);
                // await File(pathOfImage).delete();
              }
              selectionEnabled = false;
              selectedImageKeys.clear();
              selectedImageOdeject.clear();
              setState(() {});
            },
            icon: Icon(Icons.restore),
          ),
          IconButton(
            onPressed: () {
              var box = Hive.box<Gallery>('gallery');
              var box1 = Hive.box('restor');
              print("${selectedImageOdeject.length}");
              print("${selectedImageKeys.length}");
              for (int i = 0; i < selectedImageOdeject.length; i++) {
                box.delete(selectedImageKeys[i]);
                box1.add(
                  Restor(
                    type: 'image',
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
            () => ImageViewPage(image: image,data: data),
            transition: Transition.fade,
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
          // showDialog(
          //   context: context,
          //   barrierColor: Colors.transparent,
          //   builder: (context) => ImageViewPage(image: image),
          // );
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
            borderRadius: BorderRadius.circular(
              getProportionateScreenHeight(7),
            ),
          ),
          child: selected
              ? const Align(
                  alignment: Alignment.topRight,
                  child: Icon(Icons.check_circle, color: fourthColor),
                )
              : null,
        ));
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
