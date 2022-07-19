import 'package:flutter/material.dart';
import 'package:practical/enum/font_type.dart';
import 'package:practical/ui/common/routes.dart';
import 'package:practical/ui/common/stringConstant.dart';
import 'package:practical/ui/common/widget/app_theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:practical/ui/common/widget/custom_progress_dialog.dart';
import 'package:practical/ui/common/widget/custom_tool_tip.dart';

import 'di/app_component_base.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  String initialRoute = RouteName.root;
  runApp(PracticalApp(initialRoute));
}

class PracticalApp extends StatefulWidget {
  String? initialRoute;

  PracticalApp(this.initialRoute);

  @override
  State<PracticalApp> createState() => _PracticalAppState();
}

class _PracticalAppState extends State<PracticalApp> {
  bool isInternet = false;

  @override
  Widget build(BuildContext context) {
    final _appTheme = AppTheme.of(context);
    return AppTheme(
        child: ScreenUtilInit(
            designSize: Size(
                _appTheme.expectedDeviceWidth, _appTheme.expectedDeviceWidth),
            builder: (context, child) {
              return MaterialApp(
                routes: Routes.baseRoutes,
                initialRoute: widget.initialRoute,
                builder: (context, widget) {
                  final _appTheme = AppTheme.of(context);
                  return Scaffold(
                    body: Stack(
                      children: <Widget>[
                        widget!,
                        Align(
                          alignment: FractionalOffset.fromOffsetAndSize(
                              Offset(0, _appTheme.getResponsiveHeight(35)),
                              MediaQuery
                                  .of(context)
                                  .size),
                          child: StreamBuilder<bool>(
                              initialData: true,
                              stream: AppComponentBase
                                  .getInstance()
                                  ?.getNetworkManager()
                                  .internetConnectionStream,
                              builder: (context, snapshot) {
                                if (snapshot.data != null &&
                                    snapshot.data != isInternet) {
                                  isInternet = snapshot.data!;
                                  print("isInternet = $isInternet");
                                } else {
                                  isInternet = snapshot.data!;
                                  print("isInternet = $isInternet");
                                }
                                return SafeArea(
                                  child: AnimatedContainer(
                                      height: !snapshot.data! ? _appTheme.getResponsiveHeight(100) : 0,
                                      duration: const Duration(milliseconds: 200),
                                      color: _appTheme.redColor,
                                      child: Material(
                                        type: MaterialType.transparency,
                                        child: Center(
                                            child:
                                            Text(StringConstants.noInternetConnection, style: _appTheme.customTextStyle(
                                              fontSize: 38,
                                              color: _appTheme.whiteColor,
                                              fontFamilyType: FontFamilyType.Poppins,
                                              fontWeightType: FontWeightType.Regular
                                            ))),
                                      )),
                                );
                              }),
                        ),
                        StreamBuilder<bool>(
                            initialData: false,
                            stream: AppComponentBase
                                .getInstance()
                                ?.progressDialogStream,
                            builder: (context, snapshot) {
                              return snapshot.data!
                                  ? Center(child: CustomProgressDialog())
                                  : const Offstage();
                            })
                      ],
                    ),
                  );
                },
              );
            }
        ));
  }
}
