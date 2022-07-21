import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:practical/ui/cart/cart_bloc.dart';
import 'package:practical/ui/common/widget/app_theme.dart';

import '../../enum/font_type.dart';
import '../../model/cart.dart';
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
            MediaQuery.of(context).size.width, AppBar().preferredSize.height),
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
          Expanded(child: _getCartList(_appTheme)),
          _getBottomBar(_appTheme)
        ],
      ),
    );
  }

  Widget _getCartList(AppThemeState _appTheme) {
    return StreamBuilder<List<Cart>>(
        stream: _cartBloc.cartProductStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return snapshot.data != null
                ? ListView.builder(
                    itemCount: snapshot.data?.length,
                    itemBuilder: (context, index) {
                      return _getCartItem(_appTheme, snapshot.data?[index]);
                    })
                : _getEmptyTextField(_appTheme);
          } else {
            return const Center(
              child: CupertinoActivityIndicator(),
            );
          }
        });
  }

  Widget _getCartItem(AppThemeState _appTheme, Cart? cart) {
    debugPrint("product = ${cart?.product}");
    return Container(
      padding: EdgeInsets.only(right: _appTheme.getResponsiveWidth(20)),
      margin: EdgeInsets.only(
          left: _appTheme.getResponsiveWidth(48),
          right: _appTheme.getResponsiveWidth(48),
          bottom: _appTheme.getResponsiveHeight(20)),
      decoration: BoxDecoration(
        color: _appTheme.whiteColor,
        border: Border.all(
            color: _appTheme.primaryColor,
            width: _appTheme.getResponsiveWidth(2)),
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
                    bottomLeft:
                        Radius.circular(_appTheme.getResponsiveHeight(20))),
                color: _appTheme.primaryColor,
                image: DecorationImage(
                    image: NetworkImage(
                  cart?.product?.featuredImage ?? '',
                ))),
          ),
          Expanded(
              child: Padding(
            padding: EdgeInsets.only(left: _appTheme.getResponsiveWidth(45)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _getSizedBox(_appTheme, height: 8),
                Text(
                  cart?.product?.title ?? '',
                  style: _appTheme.customTextStyle(
                      fontFamilyType: FontFamilyType.poppins,
                      fontWeightType: FontWeightType.regular,
                      fontSize: 34,
                      color: _appTheme.blackColor),
                ),
                _getSizedBox(_appTheme, height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(StringConstants.price,
                        style: _appTheme.customTextStyle(
                            fontFamilyType: FontFamilyType.poppins,
                            fontWeightType: FontWeightType.medium,
                            fontSize: 30,
                            color: _appTheme.greyColor)),
                    Text(cart?.product?.price.toString() ?? '',
                        style: _appTheme.customTextStyle(
                            fontFamilyType: FontFamilyType.poppins,
                            fontWeightType: FontWeightType.regular,
                            fontSize: 30,
                            color: _appTheme.blackColor)),
                  ],
                ),
                _getSizedBox(_appTheme, height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(StringConstants.quantity,
                        style: _appTheme.customTextStyle(
                            fontFamilyType: FontFamilyType.poppins,
                            fontWeightType: FontWeightType.medium,
                            fontSize: 30,
                            color: _appTheme.greyColor)),
                    Text(cart?.productQuantity.toString() ?? '',
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

  Widget _getSizedBox(AppThemeState _appTheme,
      {double width = 0.0, double height = 0.0}) {
    return SizedBox(
      height: _appTheme.getResponsiveHeight(height),
      width: _appTheme.getResponsiveWidth(width),
    );
  }

  Widget _getEmptyTextField(AppThemeState _appTheme) {
    return Center(
      child: Text(
        StringConstants.cartIsEmpty,
        style: _appTheme.customTextStyle(
            fontSize: 40,
            fontWeightType: FontWeightType.regular,
            fontFamilyType: FontFamilyType.poppins,
            color: _appTheme.greyColor),
      ),
    );
  }

  Widget _getBottomBar(AppThemeState _appTheme) {
    return StreamBuilder<int>(
        stream: _cartBloc.totalPriceStream,
        builder: (context, snapshot) {
          return Container(
            color: _appTheme.primaryColor.withOpacity(0.5),
            padding: EdgeInsets.all(_appTheme.getResponsiveWidth(30)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(StringConstants.totalItems,
                        style: _appTheme.customTextStyle(
                            fontFamilyType: FontFamilyType.poppins,
                            fontWeightType: FontWeightType.medium,
                            fontSize: 30,
                            color: _appTheme.greyColor)),
                    _getSizedBox(_appTheme, width: 10),
                    Text(_cartBloc.listCart.length.toString() ?? '',
                        style: _appTheme.customTextStyle(
                            fontFamilyType: FontFamilyType.poppins,
                            fontWeightType: FontWeightType.regular,
                            fontSize: 30,
                            color: _appTheme.blackColor)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(StringConstants.grandTotal,
                        style: _appTheme.customTextStyle(
                            fontFamilyType: FontFamilyType.poppins,
                            fontWeightType: FontWeightType.medium,
                            fontSize: 30,
                            color: _appTheme.greyColor)),
                    _getSizedBox(_appTheme, width: 10),
                    Text(snapshot.data.toString() ?? '',
                        style: _appTheme.customTextStyle(
                            fontFamilyType: FontFamilyType.poppins,
                            fontWeightType: FontWeightType.regular,
                            fontSize: 30,
                            color: _appTheme.blackColor)),
                  ],
                ),
              ],
            ),
          );
        });
  }
}
