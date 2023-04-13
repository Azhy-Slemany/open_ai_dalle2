import 'dart:math';

import 'package:flutter/material.dart';

class Images {
  static const String PLACEHOLDER = 'assets/images/placeholders/';
  static const String IMAGE_BIRD = PLACEHOLDER + 'bird.png';
  static List<String> birdImageList = [IMAGE_BIRD];

  static const String IMAGE_ANGRY_BIRD = PLACEHOLDER + 'angry_bird.png';
  static const String IMAGE_ANGRY_BIRD_2 = PLACEHOLDER + 'angry_bird_2.png';
  static const String IMAGE_ANGRY_BIRD_3 = PLACEHOLDER + 'angry_bird_3.png';
  static const String IMAGE_ANGRY_BIRD_4 = PLACEHOLDER + 'angry_bird_4.png';
  static List<String> angryBirdImagesList = [
    IMAGE_ANGRY_BIRD,
    IMAGE_ANGRY_BIRD_2,
    IMAGE_ANGRY_BIRD_3,
    IMAGE_ANGRY_BIRD_4
  ];

  static const String IMAGE_CHESS_PAWN = PLACEHOLDER + 'chess_pawn.png';
  static const String IMAGE_CHESS_KNIGHT = PLACEHOLDER + 'chess_knight.png';
  static const String IMAGE_CHESS_BISHOP = PLACEHOLDER + 'chess_bishop.png';
  static const String IMAGE_CHESS_ROOK = PLACEHOLDER + 'chess_rook.png';
  static const String IMAGE_CHESS_QUEEN = PLACEHOLDER + 'chess_queen.png';
  static const String IMAGE_CHESS_KING = PLACEHOLDER + 'chess_king.png';
  static List<String> chessImagesList = [
    IMAGE_CHESS_PAWN,
    IMAGE_CHESS_KNIGHT,
    IMAGE_CHESS_BISHOP,
    IMAGE_CHESS_ROOK,
    IMAGE_CHESS_QUEEN,
    IMAGE_CHESS_KING
  ];

  static List<List<String>> allPlaceHolders = [];

  static List<String> get getImages => [
        IMAGE_BIRD,
        IMAGE_ANGRY_BIRD,
        IMAGE_ANGRY_BIRD_2,
        IMAGE_ANGRY_BIRD_3,
        IMAGE_ANGRY_BIRD_4,
        IMAGE_CHESS_PAWN,
        IMAGE_CHESS_KNIGHT,
        IMAGE_CHESS_BISHOP,
        IMAGE_CHESS_ROOK,
        IMAGE_CHESS_QUEEN,
        IMAGE_CHESS_KING
      ];

  static void precacheImages(BuildContext context, {placeholderMax = 10}) {
    getImages.forEach((element) {
      precacheImage(AssetImage(element), context);
    });

    //also fill the placeholder lists with images
    allPlaceHolders = [birdImageList, angryBirdImagesList, chessImagesList];

    for (var i = 0; i < allPlaceHolders.length; i++) {
      //first fill the list to 10
      var length = allPlaceHolders[i].length;
      for (var j = length; j < 10; j++) {
        allPlaceHolders[i].add(allPlaceHolders[i][j % length]);
      }
    }
  }

  static List<String> getRandomPlaceholders({bool shuffle = false}) {
    var result = allPlaceHolders[Random().nextInt(allPlaceHolders.length)];
    if (shuffle) {
      result.shuffle();
    }
    return result;
  }
}
