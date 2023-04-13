import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:open_ai_dalle2/animations.dart';
import 'package:open_ai_dalle2/image.dart';
import 'package:open_ai_dalle2/models/generated_image.dart';
import 'package:open_ai_dalle2/pages/display_images.dart';
import 'package:open_ai_dalle2/requests.dart';

class ImageGenerator extends StatefulWidget {
  ImageGenerator();

  State<ImageGenerator> createState() => _ImageGeneratorState();
}

class _ImageGeneratorState extends State<ImageGenerator>
    with TickerProviderStateMixin {
  _ImageGeneratorState();

  final TextEditingController _promptController = TextEditingController();
  int imageCount = 1;
  final ScrollController _scrollController = ScrollController();
  late AnimationController placeholderAnimationController;
  late final Animation<double> placeholderAnimation;

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
  }

  @override
  void dispose() {
    placeholderAnimationController.dispose();
    this._promptController.dispose();
    this._scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Image Generator')),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    controller: _promptController,
                    decoration: InputDecoration(
                        labelText: 'Prompt',
                        hintText: 'A robot playing chess with an alien'),
                  ),
                ),
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
                          margin:
                              EdgeInsets.only(top: 10, left: 10, bottom: 10),
                          child: Text('Number of Images to Generate'),
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
                generating
                    ? Container(
                        height: 60,
                        padding: EdgeInsets.all(5),
                        child: LoadingIndicator(
                            indicatorType: Indicator.ballScaleRipple))
                    : Container(
                        padding: EdgeInsets.all(5),
                        child: ElevatedButton(
                          onPressed: () async {
                            final prompt = _promptController.text;

                            //validate both prompt and imageCount to check if they follow the rules
                            if (prompt.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text('Prompt cannot be empty')));
                              return;
                            }

                            if (prompt.length >= 1000) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text(
                                      'Prompt cannot be more than 1000 characters')));
                              return;
                            }

                            /*if (imageCount == null) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text(
                                        'Number of images must be an integer')));
                                return;
                              }

                              if (imageCount < 1 || imageCount > 10) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text(
                                        'Number of images must be between 1 and 10')));
                                return;
                              }*/

                            setState(() {
                              generating = true;
                              placeholders = Images.getRandomPlaceholders();
                            });

                            GeneratedImage result =
                                await generateImageForTest(imageCount);
                            /*generateImage(prompt,
                                    n: imageCount, keyIndex: 1);*/

                            setState(() {
                              generating = false;
                              this.result = result;
                            });

                            /*if (result.isCreated) {
                              print('succeeded');
                              print(result.images);
                            } else {
                              print('failed');
                              print(result.error);
                            }*/

                            if (!result.isCreated) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text(
                                      'Failed to generate images, ${result.error}}')));
                              return;
                            }
                          },
                          child: Text('Generate Image'),
                        ),
                      ),
              ],
            ),
            result == null
                ? SizedBox(height: 250)
                : InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => DisplayImages(
                                generatedImage: result!,
                                prompt: _promptController.text,
                              )));
                    },
                    child: Card(
                      child: SizedBox(
                          height: 250,
                          child: Hero(
                            tag: 'imagesGridview',
                            child: GridView.builder(
                              controller: _scrollController,
                              physics: BouncingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: result!.images.length,
                              itemBuilder: (context, index) =>
                                  CachedNetworkImage(
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
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Container(
                                                      height: 150,
                                                      width: 150,
                                                      padding:
                                                          EdgeInsets.all(20),
                                                      child: FadeTransition(
                                                        opacity:
                                                            placeholderAnimationController,
                                                        child: Image.asset(
                                                          placeholders![index],
                                                        ),
                                                      )),
                                                  Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 2),
                                                    child:
                                                        LinearProgressIndicator(
                                                      value: progress.progress,
                                                      minHeight: 0.9,
                                                      color: Colors.black,
                                                      backgroundColor:
                                                          Colors.grey,
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
                          )),
                    ),
                  )
          ],
        ));
  }
}
