import 'package:flutter/material.dart';

import '../utils.dart';
import 'app_theme.dart';

class CustomToolTip extends StatefulWidget {
  final String message;
  final TextStyle messageTextStyle;
  final IconData icon;

  CustomToolTip(
      {required this.message,
      required this.messageTextStyle,
      required this.icon});

  @override
  State<StatefulWidget> createState() {
    return CustomToolTipState();
  }
}

class CustomToolTipState extends State<CustomToolTip>
    with TickerProviderStateMixin {
  bool isOpened = false;
  late AppThemeState _appTheme;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: Utils.animationDuration,
        vsync: this,
        lowerBound: 0.5,
        upperBound: 1);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.ease);
    _controller.addListener(() {
      if (_controller.isCompleted) {
        _controller.reverse();
      } else if (_controller.isDismissed) {
        _controller.forward();
      }
    });
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    _appTheme = AppTheme.of(context);
    return GestureDetector(
      onTap: () {
        setState(() {
          isOpened = !isOpened;
        });
      },
      child: Container(
        margin: EdgeInsets.only(right: _appTheme.getResponsiveWidth(30)),
        height: _appTheme.getResponsiveHeight(100),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            AnimatedContainer(
                padding: EdgeInsets.all(_appTheme.getResponsiveWidth(10)),
                width: isOpened ? _appTheme.getResponsiveWidth(700) : 0,
                duration: Utils.animationDuration,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                        Radius.circular(_appTheme.getResponsiveHeight(10)))),
                child: Center(
                    child: Text(
                  widget.message,
                  style: widget.messageTextStyle,
                  maxLines: 1,
                ))),
            ScaleTransition(
                scale: _animation,
                child: Icon(
                  widget.icon,
                  color: Colors.white,
                  size: _appTheme.getResponsiveHeight(100),
                )),
          ],
        ),
      ),
    );
  }

  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }
}
