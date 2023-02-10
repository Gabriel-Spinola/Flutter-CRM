import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class AppLayout {
  // Returns size of the mediaQuery
  static Size getSize(BuildContext context) {
    return MediaQuery.of(context).size;
  }

  static double getScreenHeight() => Get.height;
  static double getScreenWidth() => Get.width;

  static double getHeight(double pixels) {
    double screenProportion = getScreenHeight() / pixels;

    return getScreenHeight() / screenProportion;
  }

  static double getWidth(double pixels) {
    double screenProportion = getScreenWidth() / pixels;

    return getScreenWidth() / screenProportion;
  }
}
