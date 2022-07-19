import 'package:flutter/material.dart';

import 'app_theme.dart';

class CustomProgressDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _appTheme = AppTheme.of(context);
    return Container(
      width: _appTheme.getResponsiveHeight(200),
      height: _appTheme.getResponsiveHeight(200),
      decoration: BoxDecoration(
          color: _appTheme.blackColor.withOpacity(0.5),
          borderRadius: BorderRadius.all(
              Radius.circular(_appTheme.getResponsiveHeight(10)))),
      child: Center(
        child: Container(
          height: _appTheme.getResponsiveHeight(100),
          width: _appTheme.getResponsiveHeight(100),
          child: CircularProgressIndicator(
             strokeWidth: _appTheme.getResponsiveWidth(8),
            valueColor: AlwaysStoppedAnimation<Color>(_appTheme.primaryColor),
          ),
        ),
      ),
    );
  }
}
