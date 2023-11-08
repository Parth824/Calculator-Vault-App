import 'dart:io';
import 'dart:typed_data';
import 'package:calculator_vault_app/colors.dart';
import 'package:calculator_vault_app/size_config.dart';
import 'package:calculator_vault_app/src/views/screens/options/video/videoviewcontorller.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import '../../../../models/gallery_model.dart';
import '../../../../models/restor_model.dart';

class VideoViewPage extends StatefulWidget {
  final Gallery image;
  final List<Gallery> data;

  const VideoViewPage({super.key, required this.image, required this.data});

  @override
  State<VideoViewPage> createState() => _VideoViewPageState();
}

class _VideoViewPageState extends State<VideoViewPage> {
  VideoPlayerController? controller;
  late File file;
  ImageVoideController imageViewController = Get.put(ImageVoideController());
  PageController? pageController;

  @override
  void initState() {
    super.initState();

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
    getdata();
  }

  getdata() async {
    Uint8List imageInUnit8List = widget
        .data[imageViewController.currentIndex.value]
        .bytes; // store unit8List image here ;
    final tempDir = await getTemporaryDirectory();
    file = await File('${tempDir.path}/image.mp4').create();
    file.writeAsBytesSync(imageInUnit8List);
    print(file.path);
    controller = VideoPlayerController.file(file)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {
          controller!.play();
        });
      });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller!.dispose();
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
              onPageChanged: (val) {
                imageViewController.currentIndex.value = val;
                getdata();
              },
              itemBuilder: (context, index) {
                return Container(
                  height: SizeConfig.screenHeight,
                  width: SizeConfig.screenWidth,
                  child: InteractiveViewer(
                    child: Hero(
                      tag: widget.data[index].key.toString(),
                      child: (controller != null)
                          ? AspectRatio(
                              aspectRatio: controller!.value.aspectRatio,
                              child: VideoPlayer(controller!),
                            )
                          : Container(),
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
                type: 'video',
                thumbnailBytes: widget.data[imageViewController.currentIndex.value].thumbnailBytes,
                bytes: widget.data[imageViewController.currentIndex.value].bytes,
                dateTime: DateTime.now(),
                localPath: widget.data[imageViewController.currentIndex.value].localPath,
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
