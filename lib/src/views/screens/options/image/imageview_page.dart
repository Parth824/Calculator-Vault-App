import 'package:calculator_vault_app/colors.dart';
import 'package:calculator_vault_app/size_config.dart';
import 'package:calculator_vault_app/src/views/screens/options/image/imageviewcontorller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../../../../models/gallery_model.dart';
import '../../../../models/restor_model.dart';

class ImageViewPage extends StatefulWidget {
  final Gallery image;
  final List<Gallery> data;

  const ImageViewPage({super.key, required this.image, required this.data});

  @override
  State<ImageViewPage> createState() => _ImageViewPageState();
}

class _ImageViewPageState extends State<ImageViewPage> {
  ImageViewController imageViewController = Get.put(ImageViewController());
  PageController? pageController;
  @override
  void initState() {
    imageViewController.imageList.value = widget.data;
    for (int i = 0; i < imageViewController.imageList.length; i++) {
      if (imageViewController.imageList[i].key == widget.image.key) {
        imageViewController.currentIndex.value = i;
        break;
      }
    }
    print("${imageViewController.currentIndex.value}");
    pageController =
        PageController(initialPage: imageViewController.currentIndex.value);
    super.initState();
  }

  void _animateSlider() {
    Future.delayed(const Duration(seconds: 3)).then((_) {
      imageViewController.currentIndex.value++;
      if (imageViewController.currentIndex.value ==
          imageViewController.imageList.length) {
        imageViewController.currentIndex.value = 0;
      }
      if (pageController!.hasClients) {
        pageController!
            .animateToPage(imageViewController.currentIndex.value,
                duration: const Duration(seconds: 1), curve: Curves.linear)
            .then((_) => _animateSlider());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: firstColor,
        body: Stack(
          children: [
            PageView.builder(
              itemCount: imageViewController.imageList.length,
              controller: pageController,
              onPageChanged: (value) {
                imageViewController.currentIndex.value = value;
              },
              itemBuilder: (context, index) {
                return Obx(
                  () => Container(
                    height: SizeConfig.screenHeight,
                    width: SizeConfig.screenWidth,
                    child: InteractiveViewer(
                      child: Hero(
                        tag:
                            imageViewController.imageList[index].key.toString(),
                        child: Image.memory(
                          imageViewController.imageList[index].bytes,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            Row(
              children: [
                SizedBox(
                  width: SizeConfig.screenWidth * 0.04,
                ),
                GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    )),
                Spacer(),
                popUpMenu(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  popUpMenu() {
    return PopupMenuButton<int>(
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 1,
          onTap: () {
            var box1 = Hive.box('restor');
            box1.add(
              Restor(
                type: 'image',
                thumbnailBytes: widget
                    .data[imageViewController.currentIndex.value]
                    .thumbnailBytes,
                bytes:
                    widget.data[imageViewController.currentIndex.value].bytes,
                dateTime: DateTime.now(),
                localPath: widget
                    .data[imageViewController.currentIndex.value].localPath,
              ),
            );
            widget.data[imageViewController.currentIndex.value].delete();
            Navigator.pop(context);
          },
          child: menuItem(Icons.delete, "Delete", Colors.red),
        ),
      ],
      offset: const Offset(0, 50),
      color: Colors.white,
      elevation: 2,
      // padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      constraints: const BoxConstraints(minWidth: 128),
    );
  }

  menuItem(IconData iconData, String lable, [Color? color]) {
    return Row(
      children: [
        Icon(iconData, color: color),
        const Spacer(),
        Text(
          lable,
          style: TextStyle(
            color: color ?? Colors.white,
          ),
        ),
        const Spacer(),
      ],
    );
  }
}
