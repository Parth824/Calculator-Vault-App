import 'package:calculator_vault_app/size_config.dart';
import 'package:calculator_vault_app/src/models/restor_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import '../../../../../colors.dart';
import '../../../../models/gallery_model.dart';

class RecyclePage extends StatefulWidget {
  const RecyclePage({super.key});

  @override
  State<RecyclePage> createState() => _RecyclePageState();
}

class _RecyclePageState extends State<RecyclePage> {
  bool selectionEnabled = false;
  List<int> selectedImageKeys = [];
  List<Restor> selectedImageOdeject = [];
  List images = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
  }

  getdata() async {
    await Hive.openBox("restor");
    // await Hive.openBox("gallery");
    images = Hive.box("restor").values.toList();

    setState(() {});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  getdat() async {}

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
            "Recycle Bin",
            style: TextStyle(fontFamily: "Gilroy"),
          ),
        ),
        // floatingActionButton: FloatingActionButton(
        //   backgroundColor: fourthColor,
        //   onPressed: () async {
        //     storagePermissionCheck(
        //       onPermissionGranted: () async {
        //         Get.to(
        //               () => VideoPickerPage(),
        //           curve: Curves.easeInOut,
        //           transition: Transition.fade,
        //           duration: Duration(
        //             milliseconds: 500,
        //           ),
        //         );
        //       },
        //       onPermissionDenied: () => permissionDeniedSnackBar(context),
        //     );
        //   },
        //   child: Icon(
        //     Icons.add,
        //     color: firstColor,
        //     size: getProportionateScreenHeight(25),
        //   ),
        // ),
        body:
            // FutureBuilder<Box<Restor>>(
            //   future: Hive.openBox('restor'),
            //   builder: (context, galleryBoxSnapshot) {
            //     if (galleryBoxSnapshot.hasError) {
            //       return Center(
            //         child: Text(galleryBoxSnapshot.error.toString()),
            //       );
            //     }
            //     if (galleryBoxSnapshot.hasData && galleryBoxSnapshot.data != null) {
            //       return ValueListenableBuilder<Box<Restor>>(
            //         valueListenable: galleryBoxSnapshot.data!.listenable(),
            //         builder: (context, galleryBox, child) {
            //           final images = Hive.box("restor").values
            //               .where((element) => element.type == "image")
            //               .toList();
            //           if (images.isEmpty) {
            //             return Center(
            //               child: Text(
            //                 "Add Images Here!",
            //                 style: TextStyle(
            //                     fontSize: getProportionateScreenHeight(16),
            //                     color: Colors.white,
            //                     fontFamily: "Gilroy"),
            //               ),
            //             );
            //           }
            //
            //           print(selectedImageKeys);
            //           return
            (images.isNotEmpty)
                ? GridView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: images.length,
                    itemBuilder: (context, index) {
                      print(selectedImageKeys);
                      return imageGrid(context, images[index],
                          selectedImageKeys.contains(images[index].key));
                    },
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 120,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                    ),
                  )
                : Center(
                    child: Text(
                      "Recycle Bin is Empty...",
                      style: TextStyle(
                          fontFamily: "Gilroy",
                          fontSize: getProportionateScreenHeight(16),
                          color: Colors.white),
                    ),
                  ),
        //         },
        //       );
        //     } else {
        //       return const Center(
        //         child: CircularProgressIndicator(),
        //       );
        //     }
        //   },
        // ),
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
            onPressed: () {
              final box = Hive.box('restor');
              final box1 = Hive.box<Gallery>('gallery');
              for (int i = 0; i < selectedImageOdeject.length; i++) {
                box.delete(selectedImageKeys[i]);
                (selectedImageOdeject[i].type == "image")
                    ? box1.add(
                        Gallery(
                          type: 'image',
                          thumbnailBytes:
                              selectedImageOdeject[i].thumbnailBytes,
                          bytes: selectedImageOdeject[i].bytes,
                          dateTime: DateTime.now(),
                          localPath: selectedImageOdeject[i].localPath,
                        ),
                      )
                    : box1.add(
                        Gallery(
                          type: 'video',
                          thumbnailBytes:
                              selectedImageOdeject[i].thumbnailBytes,
                          bytes: selectedImageOdeject[i].bytes,
                          dateTime: DateTime.now(),
                          localPath: selectedImageOdeject[i].localPath,
                        ),
                      );
              }
              images = Hive.box("restor").values.toList();
              selectionEnabled = false;
              selectedImageKeys.clear();
              selectedImageOdeject.clear();
              setState(() {});
            },
            icon: const Icon(Icons.restore),
          ),
          SizedBox(
            width: 10,
          ),
          IconButton(
            onPressed: () {
              final box = Hive.box('restor');
              for (var key in selectedImageKeys) {
                box.delete(key);
              }
              images = Hive.box("restor").values.toList();
              selectionEnabled = false;
              selectedImageKeys.clear();
              setState(() {});
            },
            icon: const Icon(Icons.delete),
          ),
        ],
      );
    }
  }

  GestureDetector imageGrid(context, Restor image, bool selected) {
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

          // image.type == "video"?Get.to(
          //       () => VideoViewPage(image: image),
          //   transition: Transition.fade,
          //   duration: Duration(milliseconds: 500),
          //   curve: Curves.easeInOut,
          // ):Get.to(
          //       () => ImageViewPage(image: image),
          //   transition: Transition.fade,
          //   duration: Duration(milliseconds: 500),
          //   curve: Curves.easeInOut,
          // );
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
            borderRadius: BorderRadius.circular(getProportionateScreenHeight(7))
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
