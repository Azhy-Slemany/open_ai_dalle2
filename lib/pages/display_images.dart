import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:open_ai_dalle2/models/generated_image.dart';
import 'package:open_ai_dalle2/requests.dart';
import 'package:open_ai_dalle2/file_operations.dart';

class DisplayImages extends StatefulWidget {
  const DisplayImages(
      {Key? key, required this.generatedImage, required this.prompt})
      : super(key: key);

  final GeneratedImage generatedImage;
  final String prompt;

  @override
  State<DisplayImages> createState() =>
      _DisplayImagesState(generatedImage, prompt);
}

class _DisplayImagesState extends State<DisplayImages>
    with TickerProviderStateMixin {
  _DisplayImagesState(this.gImage, this.prompt);

  final GeneratedImage gImage;
  final String prompt;
  final ScrollController _scrollController = ScrollController();
  List<String>? placeholders;
  late AnimationController placeholderAnimationController;
  bool isSaving = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    placeholderAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    placeholderAnimationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    placeholderAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Display Images')),
      body: Directionality(
          textDirection: TextDirection.ltr,
          child: Hero(
            tag: 'imagesGridview',
            child: GridView.builder(
              controller: _scrollController,
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: gImage.images.length,
              itemBuilder: (context, index) => GestureDetector(
                onTap: () => showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => saveDialog(
                    gImage.images[index],
                    prompt,
                  ),
                ),
                child: CachedNetworkImage(
                    imageUrl: gImage.images[index],
                    fit: BoxFit.cover,
                    progressIndicatorBuilder: (context, url, progress) =>
                        Container(
                          decoration: BoxDecoration(
                              border: Border(
                                  right: BorderSide(color: Colors.black))),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                    height: 150,
                                    width: 150,
                                    padding: EdgeInsets.all(20),
                                    child: FadeTransition(
                                      opacity: placeholderAnimationController,
                                      child: Image.asset(
                                        placeholders![index],
                                      ),
                                    )),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 2),
                                  child: LinearProgressIndicator(
                                    value: progress.progress,
                                    minHeight: 0.9,
                                    color: Colors.black,
                                    backgroundColor: Colors.grey,
                                  ),
                                ),
                              ]),
                        )),
              ),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1,
              ),
            ),
          )),
    );
  }

  Widget saveDialog(String imageUrl, String prompt) {
    return StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
        contentPadding: EdgeInsets.zero,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
            ),
            InkWell(
              child: Container(
                decoration: BoxDecoration(color: Colors.black87),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                        padding: EdgeInsets.all(10),
                        child: isSaving
                            ? CircularProgressIndicator()
                            : Text(
                                'Save',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              )),
                  ],
                ),
              ),
              onTap: () async {
                setState(() {
                  isSaving = true;
                });
                bool isSaved = await FileOperations.saveImage(imageUrl, prompt);
                setState(() {
                  isSaving = false;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(isSaved
                        ? 'Image saved successfully'
                        : 'Error: Image could not be saved'),
                  ),
                );
                Navigator.pop(context, 'Cancel');
              },
            )
          ],
        ),
      );
    });
  }
}
