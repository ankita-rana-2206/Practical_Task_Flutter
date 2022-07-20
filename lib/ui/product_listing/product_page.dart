import 'package:flutter/material.dart';
import 'package:practical/di/app_component_base.dart';
import 'package:practical/ui/common/widget/app_theme.dart';
import 'package:practical/ui/product_listing/product_bloc.dart';

import '../../enum/font_type.dart';
import '../../model/product.dart';
import '../common/asset_images.dart';
import '../common/routes.dart';
import '../common/stringConstant.dart';
import '../common/widget/common_app_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({Key? key}) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  late AppThemeState _appThemeState;
  final ProductBloc _productBloc = ProductBloc();


  @override
  void initState() {
    _productBloc.fetchProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _appThemeState = AppTheme.of(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(
            MediaQuery
                .of(context)
                .size
                .width, AppBar().preferredSize.height),
        child: CommonAppBar(
          title: StringConstants.shoppingMall,
          elevation: 0.2,
          isBackButtonVisible: false,
          centerTitle: true,
          actions: [
            _getTitleCartIcon(_appThemeState)
          ],
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(top: _appThemeState.getResponsiveHeight(30)),
        child: _getProductItems(_appThemeState),
      ),
    );
  }

  Widget _getProductItems(AppThemeState _appTheme) {
    return StreamBuilder<List<Product>>(
      stream: _productBloc.productStream,
        builder: (context, snapshot) {
          debugPrint("builder_data = ${snapshot.data}");
      return snapshot.data != null ? Container(
        margin: EdgeInsets.only(left: _appTheme.getResponsiveWidth(48), right: _appTheme.getResponsiveWidth(48)),
        child: GridView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.6,
              crossAxisSpacing: _appTheme.getResponsiveWidth(40),
              mainAxisSpacing: _appTheme.getResponsiveHeight(40)),
          itemBuilder: (_, index) => _getProductItem(_appTheme, snapshot.data?[index]),
          itemCount: snapshot.data?.length,
        ),
      ) : const Offstage();
    });
  }

  Widget _getProductItem(AppThemeState _appTheme, Product? product) {
    return Container(
      width: _appTheme.getResponsiveWidth(480),
      decoration: BoxDecoration(
        border: Border.all(color: _appTheme.primaryColor, width: _appTheme.getResponsiveWidth(3)),
        borderRadius: const BorderRadius.all(Radius.circular(13)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _getProductImage(_appTheme, product?.featuredImage),
          _getSizedBox(_appTheme, height: 15),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _getProductName(_appTheme, product?.title),),
              _getCartIcon(_appTheme, product),
              _getSizedBox(_appTheme, width: _appTheme.getResponsiveWidth(50))
            ],
          ),
          _getSizedBox(_appTheme, height: 10),
        ],
      ),
    );
  }

  Widget _getProductImage(AppThemeState _appTheme, String? imagePath) {
    return Container(
      height: _appTheme.getResponsiveHeight(280),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(13)),
          image: DecorationImage(image: NetworkImage(imagePath??''), fit: BoxFit.cover)),
    );
  }

  Widget _getProductName(AppThemeState _appTheme, String? productName) {
    return Padding(
      padding: EdgeInsets.only(left: _appTheme.getResponsiveWidth(32)),
      child: Text(
        productName ?? '',
        style: _appTheme.customTextStyle(
            fontFamilyType: FontFamilyType.poppins,
            fontWeightType: FontWeightType.regular,
            fontSize: 34,
            color: _appTheme.blackColor),
      ),
    );
  }

  Widget _getSizedBox(AppThemeState _appTheme, {double width = 0.0, double height = 0.0}) {
    return SizedBox(
      height: _appTheme.getResponsiveHeight(height),
      width: _appTheme.getResponsiveWidth(width),
    );
  }

  Widget _getCartIcon(AppThemeState _appTheme, Product? product) {
    return InkWell(
      child: SvgPicture.asset(
        SVGPath.cartIcon,
        color: _appTheme.blackColor,
        width: _appTheme.getResponsiveWidth(30),
        height: _appTheme.getResponsiveHeight(30),
      ),
      onTap: () {
        AppComponentBase.getInstance()?.getDbHelper().insertCartDetails(product!);
      },
    );
  }

  Widget _getTitleCartIcon(AppThemeState _appTheme) {
    return InkWell(
      child: SvgPicture.asset(
        SVGPath.cartIcon,
        color: _appTheme.whiteColor,
        width: _appTheme.getResponsiveWidth(40),
        height: _appTheme.getResponsiveHeight(40),
      ),
      onTap: () {
        Navigator.of(context, rootNavigator: true)
            .pushNamed(RouteName.cartPage);
      },
    );
  }
}
