import 'package:flutter/material.dart';

import 'vars.dart';

class Dimens {
  static BuildContext? get _context => Vars.context;

  static Size get screenSize {
    if (_context == null) return const Size(0, 0);
    return MediaQuery.of(_context!).size;
  }

  static double get screenWidth => screenSize.width;

  static double get screenHeight => screenSize.height;

  static double get drawerWidth => screenWidth * 0.8;

  static const bottomAppBarNotchMargin = 8.0;
  
  static const btnElevation = 5.0;
  static const btnIconPaddingHorz = btnPaddingHorz / 2;
  static const btnPaddingHorz = btnPaddingVert * 3;
  static const btnPaddingVert = 8.0;
  static const btnRadius = 30.0;
  
  static const cardElevation = 8.0;
  static const cardRadius = 12.0;
  static const cardPadding = 8.0;

  static const drawerPadding = 8.0;
  static const drawerItemPadding = 4.0;

  static const gridSpacing = 12.0;

  static const noteGridTileHeight = 240.0;
}

class Pads {
  /// Short for [EdgeInsets.all]
  static EdgeInsets all(double val) => EdgeInsets.all(val);

  /// Short for [EdgeInsets.only]
  static EdgeInsets only(
          {double l = 0, double t = 0, double r = 0, double b = 0}) =>
      EdgeInsets.only(left: l, top: t, right: r, bottom: b);

  /// Short for [EdgeInsets.symmetric]
  static EdgeInsets sym({double h = 0, double v = 0}) =>
      EdgeInsets.symmetric(horizontal: h, vertical: v);

  /// Short for [EdgeInsets.fromLTRB]
  static EdgeInsets ltrb(double l, double t, double r, double b) =>
      EdgeInsets.fromLTRB(l, t, r, b);

  /// Short for [EdgeInsets.symmetric] with a horizontal value
  static EdgeInsets horz(double val) => sym(h: val);

  /// Short for [EdgeInsets.symmetric] with a vertical value
  static EdgeInsets vert(double val) => sym(v: val);

  /// Short for [EdgeInsets.only] with a left value
  static EdgeInsets left(double val) => only(l: val);

  /// Short for [EdgeInsets.only] with a right value
  static EdgeInsets right(double val) => only(r: val);

  /// Short for [EdgeInsets.only] with a top value
  static EdgeInsets top(double val) => only(t: val);

  /// Short for [EdgeInsets.only] with a bottom value
  static EdgeInsets bot(double val) => only(b: val);
}

class Borders {
  static const btnCircle = CircleBorder();
  static const btnRounded = RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(Dimens.btnRadius)),
  );
}