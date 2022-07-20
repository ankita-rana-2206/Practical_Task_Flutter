import 'package:flutter/material.dart';
import 'package:practical/model/product.dart';
import 'package:practical/ui/cart/cart_bloc.dart';
import 'package:practical/ui/common/widget/app_theme.dart';

import '../../enum/font_type.dart';
import '../common/stringConstant.dart';
import '../common/widget/common_app_bar.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final CartBloc _cartBloc = CartBloc();


  @override
  void initState() {
    _cartBloc.getCartItem();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppThemeState _appTheme = AppTheme.of(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(
            MediaQuery
                .of(context)
                .size
                .width, AppBar().preferredSize.height),
        child: const CommonAppBar(
          title: StringConstants.myCart,
          elevation: 0.2,
          isBackButtonVisible: false,
          centerTitle: true,
          actions: [],
        ),
      ),
      body: Column(
        children: [
          _getSizedBox(_appTheme, height: _appTheme.getResponsiveHeight(20)),
          Expanded(child: _getCartList(_appTheme))
        ],
      ),
    );
  }

  Widget _getCartList(AppThemeState _appTheme) {
    return StreamBuilder<List<Product>>(
        stream: _cartBloc.cartProductStream,
        builder: (context, snapshot) {
      return ListView.builder(
        itemCount: snapshot.data?.length,
          itemBuilder: (context, index) {
            return _getCartItem(_appTheme,snapshot.data?[index]);
          });
    });
  }

  Widget _getCartItem(AppThemeState _appTheme, Product? product) {
    return Container(
      padding: EdgeInsets.only(right: _appTheme.getResponsiveWidth(20)),
      margin: EdgeInsets.only(
          left: _appTheme.getResponsiveWidth(48),
          right: _appTheme.getResponsiveWidth(48),
          bottom: _appTheme.getResponsiveHeight(20)),
      decoration: BoxDecoration(
        color: _appTheme.whiteColor,
        border: Border.all(color: _appTheme.primaryColor, width: _appTheme.getResponsiveWidth(2)),
        borderRadius: BorderRadius.circular(_appTheme.getResponsiveHeight(20)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: _appTheme.getResponsiveWidth(250),
            height: _appTheme.getResponsiveHeight(150),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(_appTheme.getResponsiveHeight(20)),
                    bottomLeft: Radius.circular(_appTheme.getResponsiveHeight(20))),
                color: _appTheme.primaryColor,
                image: DecorationImage(
                    image: NetworkImage(
                      product?.featuredImage ?? '',
                    ))),
          ),
          Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: _appTheme.getResponsiveWidth(45)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _getSizedBox(_appTheme,height: 8),
                    Text(
                      product?.title ?? '',
                      style: _appTheme.customTextStyle(
                          fontFamilyType: FontFamilyType.poppins,
                          fontWeightType: FontWeightType.regular,
                          fontSize: 34,
                          color: _appTheme.blackColor),
                    ),
                    _getSizedBox(_appTheme,height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(StringConstants.price,
                            style: _appTheme.customTextStyle(
                                fontFamilyType: FontFamilyType.poppins,
                                fontWeightType: FontWeightType.medium,
                                fontSize: 30,
                                color: _appTheme.greyColor)),
                        Text(product?.price.toString() ?? '',
                            style: _appTheme.customTextStyle(
                                fontFamilyType: FontFamilyType.poppins,
                                fontWeightType: FontWeightType.regular,
                                fontSize: 30,
                                color: _appTheme.blackColor)),
                      ],
                    ),
                    _getSizedBox(_appTheme,height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(StringConstants.quantity,
                            style: _appTheme.customTextStyle(
                                fontFamilyType: FontFamilyType.poppins,
                                fontWeightType: FontWeightType.medium,
                                fontSize: 30,
                                color: _appTheme.greyColor)),
                        Text(product?.price.toString() ?? '',
                            style: _appTheme.customTextStyle(
                                fontFamilyType: FontFamilyType.poppins,
                                fontWeightType: FontWeightType.regular,
                                fontSize: 30,
                                color: _appTheme.blackColor)),
                      ],
                    )
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _getSizedBox(AppThemeState _appTheme, {double width = 0.0, double height = 0.0}) {
    return SizedBox(
      height: _appTheme.getResponsiveHeight(height),
      width: _appTheme.getResponsiveWidth(width),
    );
  }
}
