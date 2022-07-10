import 'dart:ui';

enum FontFamilyType { Poppins }
enum FontWeightType { Light, Regular, Medium, SemiBold, Bold }

class FontType {
  static getFontFamilyType(FontFamilyType? fontFamilyType) {
    switch (fontFamilyType) {
      case FontFamilyType.Poppins:
        return "Poppins";
      case null:
        return "";
    }
  }

  static getFontWeightType(FontWeightType? fontWeightType) {
    switch (fontWeightType) {
      case FontWeightType.Light:
        return FontWeight.w300;
      case FontWeightType.Regular:
        return FontWeight.w400;
      case FontWeightType.Medium:
        return FontWeight.w500;
      case FontWeightType.SemiBold:
        return FontWeight.w600;
      case FontWeightType.Bold:
        return FontWeight.w700;
      case null:
        return FontWeightType.Regular;
    }
  }
}