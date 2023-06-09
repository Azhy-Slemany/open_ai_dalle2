import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:open_ai_dalle2/models/generated_image.dart';
import 'package:open_ai_dalle2/requests.dart';
import 'package:open_ai_dalle2/file_operations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:open_ai_dalle2/constants.dart' as consts;

class DisplayImages extends StatefulWidget {
  const DisplayImages(
      {Key? key,
      required this.generatedImage,
      required this.placeholders,
      required this.prompt,
      required this.scrollValue})
      : super(key: key);

  final GeneratedImage generatedImage;
  final List<String>? placeholders;
  final String prompt;
  final double scrollValue;

  @override
  State<DisplayImages> createState() =>
      _DisplayImagesState(generatedImage, placeholders, prompt, scrollValue);
}

class _DisplayImagesState extends State<DisplayImages>
    with TickerProviderStateMixin {
  _DisplayImagesState(
      this.gImage, this.placeholders, this.prompt, this.scrollValue);

  final GeneratedImage gImage;
  final String prompt;
  final double scrollValue;
  bool scrollSetToPrevious = false;
  late ScrollController _scrollController =
      ScrollController(initialScrollOffset: scrollValue);
  final List<String>? placeholders;
  late AnimationController placeholderAnimationController;
  late Animation<double> placeholderAnimation;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();

    placeholderAnimationController =
        AnimationController(vsync: this, duration: Duration(seconds: 1))
          ..repeat(reverse: true, min: 0.05, max: .1);
    placeholderAnimation = CurvedAnimation(
      parent: placeholderAnimationController,
      curve: Curves.easeIn,
    );
  }

  @override
  void dispose() {
    placeholderAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(
          color: consts.whiteOrBlack(),
        ),
        title: Text(
            prompt.length > 20 ? prompt.substring(0, 20) + '...' : prompt,
            style: TextStyle(color: consts.whiteOrBlack())),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
      body: Hero(
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
                progressIndicatorBuilder: (context, url, progress) => Container(
                      decoration: BoxDecoration(
                          border:
                              Border(right: BorderSide(color: Colors.black))),
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
      ),
    );
  }

  Widget saveDialog(String imageUrl, String prompt) {
    return StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
        contentPadding: EdgeInsets.zero,
        content: CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            padding: EdgeInsets.all(10),
            height: 50,
            width: 50,
            child: LoadingIndicator(
                indicatorType: Indicator.ballScaleRippleMultiple,
                colors: [Theme.of(context).indicatorColor]),
          ),
          imageBuilder: (context, image) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image(image: image),
              InkWell(
                child: Container(
                  //decoration: BoxDecoration(color: Colors.black87),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                          padding: EdgeInsets.all(10),
                          child: isSaving
                              ? Container(
                                  height: 25,
                                  padding: EdgeInsets.all(5),
                                  child: LoadingIndicator(
                                    indicatorType:
                                        Indicator.ballScaleRippleMultiple,
                                    colors: [Theme.of(context).indicatorColor],
                                  ))
                              : Text(
                                  AppLocalizations.of(context)!.save,
                                  style: TextStyle(
                                      /*color: Colors.white,*/ fontSize: 20),
                                )),
                    ],
                  ),
                ),
                onTap: () async {
                  if (isSaving) return;
                  setState(() {
                    isSaving = true;
                  });
                  bool isSaved =
                      await FileOperations.saveImage(imageUrl, prompt);
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
        ),
      );
    });
  }
}
