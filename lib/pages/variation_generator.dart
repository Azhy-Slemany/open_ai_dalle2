import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:open_ai_dalle2/animations.dart';
import 'package:open_ai_dalle2/custom_widgets.dart';
import 'package:open_ai_dalle2/image.dart';
import 'package:open_ai_dalle2/models/generated_image.dart';
import 'package:open_ai_dalle2/pages/display_images.dart';
import 'package:open_ai_dalle2/requests.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:open_ai_dalle2/constants.dart' as consts;

class VariationGenerator extends StatefulWidget {
  VariationGenerator();

  State<VariationGenerator> createState() => _VariationGeneratorState();
}

class _VariationGeneratorState extends State<VariationGenerator>
    with TickerProviderStateMixin {
  _VariationGeneratorState();

  int imageCount = 1;
  final ScrollController _scrollController = ScrollController();
  late AnimationController placeholderAnimationController;
  late final Animation<double> placeholderAnimation;
  XFile? image;

  GeneratedImage? result;
  List<String>? placeholders;
  bool generating = false;

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

    image = null;
  }

  @override
  void dispose() {
    placeholderAnimationController.dispose();
    this._scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: CustomAppBar(AppLocalizations.of(context)!.variationsGenerator),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Container(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        onPressed: (() async {
                          ImagePicker picker = ImagePicker();
                          final XFile? image = await picker.pickImage(
                              source: ImageSource.gallery);

                          setState(() {
                            this.image = image;
                          });
                        }),
                        child: Text(AppLocalizations.of(context)!.chooseImage)),
                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          shape: BoxShape.rectangle),
                      margin: EdgeInsets.all(10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        child: this.image == null
                            ? Image.asset(Images.IMAGE_IMAGE,
                                color: consts.whiteOrBlack())
                            : Image.file(
                                File(this.image!.path),
                              ),
                      ),
                    ),
                  ],
                )),
                Container(
                  margin: EdgeInsets.only(top: 10, bottom: 10),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              color: Theme.of(context).dividerColor))),
                  child: Column(
                    children: [
                      Row(children: [
                        Container(
                          margin: EdgeInsets.only(
                              top: 10, left: 10, right: 10, bottom: 10),
                          child: Text(AppLocalizations.of(context)!
                              .numberOfImagesToGenerate),
                        )
                      ]),
                      NumberPicker(
                          minValue: 1,
                          maxValue: 10,
                          value: imageCount,
                          axis: Axis.horizontal,
                          onChanged: (v) {
                            setState(() {
                              imageCount = v;
                            });
                          }),
                    ],
                  ),
                ),
                Container(
                  height: 60,
                  margin: EdgeInsets.only(top: 5, bottom: 16),
                  child: generating
                      ? Container(
                          height: 50,
                          padding: EdgeInsets.all(5),
                          child: LoadingIndicator(
                            indicatorType: Indicator.ballScaleRipple,
                            colors: [Theme.of(context).indicatorColor],
                          ))
                      : Container(
                          margin: EdgeInsets.all(10),
                          child: ElevatedButton(
                            onPressed: () async {
                              if (this.image == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            AppLocalizations.of(context)!
                                                .pleaseSelectAnImage)));
                                return;
                              }

                              setState(() {
                                generating = true;
                                placeholders = Images.getRandomPlaceholders();
                              });

                              GeneratedImage result =
                                  await //generateImageForTest(imageCount);
                                  generateImageVariations(image!,
                                      n: imageCount,
                                      keyIndex: consts.keyIndexToUse);

                              setState(() {
                                generating = false;
                                this.result = result;
                              });

                              if (!result.isCreated) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            consts.translateErrorMessage(
                                                result.error!, context))));
                                return;
                              }
                            },
                            child: Text(
                                AppLocalizations.of(context)!.generateImages),
                          ),
                        ),
                ),
              ],
            ),
            result == null
                ? Expanded(child: SizedBox())
                : Expanded(
                    child: InkWell(
                      onTap: () {
                        if (!generating)
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => DisplayImages(
                                  generatedImage: result!,
                                  placeholders: placeholders,
                                  prompt: 'Image Variations',
                                  scrollValue: _scrollController.offset)));
                      },
                      child: Card(
                        child: Hero(
                          tag: 'imagesGridview',
                          child: GridView.builder(
                            controller: _scrollController,
                            physics: BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: result!.images.length,
                            itemBuilder: (context, index) => CachedNetworkImage(
                                imageUrl: result!.images[index],
                                fit: BoxFit.cover,
                                progressIndicatorBuilder: (context, url,
                                        progress) =>
                                    Container(
                                      decoration: BoxDecoration(
                                          border: Border(
                                              right: BorderSide(
                                                  color: Colors.black))),
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                                height: 150,
                                                width: 150,
                                                padding: EdgeInsets.all(20),
                                                child: FadeTransition(
                                                  opacity:
                                                      placeholderAnimationController,
                                                  child: Image.asset(
                                                    placeholders![index],
                                                  ),
                                                )),
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 2),
                                              child: LinearProgressIndicator(
                                                value: progress.progress,
                                                minHeight: 0.9,
                                                color: Colors.black,
                                                backgroundColor: Colors.grey,
                                              ),
                                            ),
                                          ]),
                                    )),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 1,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
          ],
        ));
  }
}
