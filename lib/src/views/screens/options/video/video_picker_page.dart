import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../../../../colors.dart';
import '../../widgets/hidevideos_floatingbutton.dart';
import '../../widgets/image_in_grid.dart';

class VideoPickerPage extends StatefulWidget {
  const VideoPickerPage({super.key});

  @override
  State<VideoPickerPage> createState() => _VideoPickerPageState();
}

class _VideoPickerPageState extends State<VideoPickerPage> {
  List<Widget> mediaList = [];
  List<AssetEntity> selectedAssets = [];

  // int currentPage = 0;
  int currentIndex = 0;
  int lastIndex = 0;

  @override
  void initState() {
    super.initState();
    _fetchNewMedia();
  }

  void _handleScrollEvent(ScrollNotification scroll) {
    if (scroll.metrics.pixels / scroll.metrics.maxScrollExtent > 0.33) {
      if (currentIndex < lastIndex) {
        _fetchNewMedia();
      }
    }
  }

  _fetchNewMedia() async {
    var result = await PhotoManager.requestPermissionExtend();
    List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
      type: RequestType.video,
    );

    AssetPathEntity? k = await albums[0].fetchPathProperties();

    List<AssetEntity> media = await albums[0].getAssetListRange(
      start: currentIndex,
      end: currentIndex + 30,
    );
    lastIndex = await albums[0].assetCountAsync;

    List<Widget> temp = [];
    for (var asset in media) {
      temp.add(
        FutureBuilder(
          future: asset.thumbnailDataWithSize(const ThumbnailSize.square(256)),
          builder: (BuildContext context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.data != null) {
                // bool selected = selectedAssets.contains(asset);
                return ImageInGrid(
                  onSelect: (selected) => setState(() {
                    selected
                        ? selectedAssets.add(asset)
                        : selectedAssets.remove(asset);
                  }),
                  bytes: snapshot.data!,
                );
              }
            }
            return Container();
          },
        ),
      );
    }
    setState(() {
      mediaList.addAll(temp);
      currentIndex += 30;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: firstColor,
      appBar: AppBar(
        backgroundColor: secondColor,
        centerTitle: true,
        title: Text(
          "Choose Videos",
          style: TextStyle(fontFamily: "Gilroy"),
        ),
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scroll) {
          _handleScrollEvent(scroll);
          return true;
        },
        child: GridView.builder(
          padding: const EdgeInsets.all(4),
          itemCount: mediaList.length,
          itemBuilder: (BuildContext context, int index) {
            return mediaList[index];
          },
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 128,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
          ),
        ),
      ),
      floatingActionButton: selectedAssets.isNotEmpty
          ? HideVideosButton(
              selectedAssets: selectedAssets,
              onHideComplete: () => Navigator.pop(context),
            )
          : null,
    );
  }
}
