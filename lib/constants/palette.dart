import 'package:sfpo/constants/packages.dart';

class Palette {
  static const MaterialColor kToDark = MaterialColor(
    // 0% comes in here, this will be color picked if no shade is selected
    // when defining a Color property which doesn’t require a swatch.
    0xFF9575CD,
    <int, Color>{
      50: Color(0xffede7f6), //10%
      100: Color(0xffd1c4e9), //20%
      200: Color(0xffb39ddb), //30%
      300: Color(0xff9575cd), //40%
      400: Color(0xff7e57c2), //50%
      500: Color(0xff673ab7), //60%
      600: Color(0xff5e35b1), //70%
      700: Color(0xff512da8), //80%
      800: Color(0xff4527a0), //90%
      900: Color(0xff311b92), //100%
    },
  );
}
