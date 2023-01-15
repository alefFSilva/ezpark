import 'package:flutter/material.dart';

class ResponsivityResizer {
  static const int _widthReference = 375;
  static const int _heightPrototypeByDesign = 667;

  static late double screenWidth;
  static late double screenHeight;
  static late final MediaQueryData _mediaQueryData;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _getSizeHorizontal();
    screenHeight = _getSizeVertical();
  }

  static double widthByPixel(double size) =>
      screenWidth * (size / _widthReference);

  static double heightByPixel(double size) =>
      screenWidth * (size / _heightPrototypeByDesign);

  double _getSizeVertical() {
    if (_mediaQueryData.orientation == Orientation.portrait) {
      return _mediaQueryData.size.height;
    }
    return _mediaQueryData.size.width;
  }

  double _getSizeHorizontal() {
    if (_mediaQueryData.orientation == Orientation.portrait) {
      return _mediaQueryData.size.width;
    }
    return _mediaQueryData.size.height;
  }
}
