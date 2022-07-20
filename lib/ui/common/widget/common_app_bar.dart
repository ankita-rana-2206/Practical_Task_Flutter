import 'package:flutter/material.dart';

import '../../../enum/font_type.dart';
import '../asset_images.dart';
import 'app_theme.dart';

class CommonAppBar extends StatefulWidget {
  /// Appbar title
  final String? title;

  /// Widgets to display after the title.
  final Widget? leading;

  /// List of Widgets to display after the title.
  /// It's the same with the action property in the default appbar widget
  final List<Widget>? actions;

  final bool centerTitle;

  final bool isBackButtonVisible;

  final bool isTitleVisible;

  final bool isLogoVisible;

  final double? leadingWidth;

  final double? elevation;

  const CommonAppBar(
      {Key? key,
      this.title,
      this.leading,
      this.actions,
      this.centerTitle = true,
      this.isBackButtonVisible = true,
      this.isTitleVisible = true,
      this.isLogoVisible = false,
      this.leadingWidth,
      this.elevation})
      : super(key: key);

  @override
  _CommonAppBarState createState() => _CommonAppBarState();
}

class _CommonAppBarState extends State<CommonAppBar> {
  @override
  Widget build(BuildContext context) {
    final _appTheme = AppTheme.of(context);
    return AppBar(
      title: _getTitle(_appTheme),
      centerTitle: widget.centerTitle,
      leading: widget.isBackButtonVisible
          ? _getBackImageOnAppbar(_appTheme)
          : widget.leading,
      leadingWidth: widget.isBackButtonVisible
          ? _appTheme.getResponsiveWidth(100)
          : widget.leadingWidth,
      actions: widget.actions,
      elevation: widget.elevation,
      backgroundColor: _appTheme.primaryColor,
    );
  }

  Widget _getTitle(AppThemeState _appTheme) {
    return Text(
      widget.title!,
      style: _appTheme.customTextStyle(
          fontSize: 50,
          color: _appTheme.whiteColor,
          fontWeightType: FontWeightType.semiBold,
          fontFamilyType: FontFamilyType.poppins),
    );
  }

  Widget _getBackImageOnAppbar(AppThemeState _appTheme) {
    return InkWell(
      child: Padding(
        padding: EdgeInsets.only(left: _appTheme.getResponsiveWidth(48)),
        child: Image.asset(
          PNGPath.backIcon,
          width: _appTheme.getResponsiveWidth(52.46),
          height: _appTheme.getResponsiveHeight(38.16),
        ),
      ),
      onTap: () {
        Navigator.of(context).pop();
      },
    );
  }
}
