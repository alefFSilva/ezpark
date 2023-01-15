import '../responsivity_resizer.dart';

extension ResizerDoubleExtension on double {
  double get height {
    return ResponsivityResizer.heightByPixel(this);
  }

  double get width {
    return ResponsivityResizer.widthByPixel(this);
  }
}

extension ResizerIntExtension on int {
  double get height {
    return toDouble().height;
  }

  double get width {
    return toDouble().width;
  }
}
