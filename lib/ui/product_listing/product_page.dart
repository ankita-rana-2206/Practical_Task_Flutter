import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:practical/di/app_component_base.dart';
import 'package:practical/ui/common/widget/app_theme.dart';
import 'package:practical/ui/product_listing/product_bloc.dart';

import '../../enum/font_type.dart';
import '../../model/product.dart';
import '../common/asset_images.dart';
import '../common/routes.dart';
import '../common/stringConstant.dart';
import '../common/widget/common_app_bar.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({Key? key}) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  late AppThemeState _appThemeState;
  final ProductBloc _productBloc = ProductBloc();
  int currentPage = 1;
  final ScrollController _scrollController = ScrollController();
  bool didEndReached = false;

  @override
  void initState() {
    _scrollController.addListener(_onScrollNotification);
    // show loader at the time of scrolling to get more data
    _productBloc.didReachToEndStreamController.stream.listen((onData) {
      //showLoadingScreen(onData);
      if (mounted) {
        setState(() {
          didEndReached = onData;
        });
      }
    });
    _productBloc.fetchProducts(currentPage);
    super.initState();
  }

  bool _onScrollNotification() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !didEndReached &&
        !_scrollController.position.outOfRange) {
      _loadMore();
    }
    return true;
  }

  // Load More data at the time of scrolling
  Future<void> _loadMore() async {
    currentPage = currentPage + 1;
    _productBloc.fetchProducts(currentPage);
    return;
  }

  @override
  Widget build(BuildContext context) {
    _appThemeState = AppTheme.of(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(
            MediaQuery.of(context).size.width, AppBar().preferredSize.height),
        child: CommonAppBar(
          title: StringConstants.shoppingMall,
          elevation: 0.2,
          isBackButtonVisible: false,
          centerTitle: true,
          actions: [_getTitleCartIcon(_appThemeState)],
        ),
      ),
      body: OrientationBuilder(builder: (context, orientation) {
        return Container(
          padding: EdgeInsets.only(top: _appThemeState.getResponsiveHeight(30)),
          child: _getProductItems(_appThemeState, orientation),
        );
      }),
    );
  }

  Widget _getProductItems(AppThemeState _appTheme, Orientation orientation) {
    return ListView(
      controller: _scrollController,
      children: [
        StreamBuilder<List<Product>>(
            stream: _productBloc.productStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return snapshot.data != null
                    ? Container(
                        margin: EdgeInsets.only(
                            left: _appTheme.getResponsiveWidth(48),
                            right: _appTheme.getResponsiveWidth(48)),
                        child: GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount:
                                      orientation == Orientation.portrait
                                          ? 2
                                          : 1,
                                  childAspectRatio: 0.6,
                                  crossAxisSpacing:
                                      _appTheme.getResponsiveWidth(40),
                                  mainAxisSpacing:
                                      _appTheme.getResponsiveHeight(40)),
                          itemBuilder: (_, index) => _getProductItem(
                              _appTheme, snapshot.data?[index], orientation),
                          itemCount: snapshot.data?.length,
                        ),
                      )
                    : _getEmptyTextField(_appTheme);
              } else {
                return const Center(
                  child: CupertinoActivityIndicator(),
                );
              }
            }),
        SizedBox(height: _appThemeState.getResponsiveHeight(30)),
        didEndReached
            ? Container()
            : const Center(
                child: CupertinoActivityIndicator(),
              ),
        SizedBox(height: _appThemeState.getResponsiveHeight(30)),
      ],
    );
  }

  Widget _getProductItem(
      AppThemeState _appTheme, Product? product, Orientation orientation) {
    return orientation == Orientation.portrait
        ? Container(
            width: _appTheme.getResponsiveWidth(480),
            decoration: BoxDecoration(
              border: Border.all(
                  color: _appTheme.primaryColor,
                  width: _appTheme.getResponsiveWidth(3)),
              borderRadius: const BorderRadius.all(Radius.circular(13)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _getProductImage(
                    _appTheme, product?.featuredImage, orientation),
                _getSizedBox(_appTheme, height: 15),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _getProductName(_appTheme, product?.title),
                    ),
                    _getCartIcon(_appTheme, product),
                    _getSizedBox(_appTheme,
                        width: _appTheme.getResponsiveWidth(50))
                  ],
                ),
                _getSizedBox(_appTheme, height: 10),
              ],
            ),
          )
        : Container(
            width: _appTheme.getResponsiveWidth(480),
            decoration: BoxDecoration(
              border: Border.all(
                  color: _appTheme.primaryColor,
                  width: _appTheme.getResponsiveWidth(3)),
              borderRadius: const BorderRadius.all(Radius.circular(13)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _getProductImage(
                    _appTheme, product?.featuredImage, orientation),
                _getSizedBox(_appTheme, width: 15),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _getProductName(_appTheme, product?.title),
                    ),
                    _getCartIcon(_appTheme, product),
                    _getSizedBox(_appTheme,
                        width: _appTheme.getResponsiveWidth(50))
                  ],
                ),
                _getSizedBox(_appTheme, height: 10),
              ],
            ),
          );
  }

  Widget _getProductImage(
      AppThemeState _appTheme, String? imagePath, Orientation orientation) {
    return Container(
      height: orientation == Orientation.portrait
          ? _appTheme.getResponsiveHeight(280)
          : _appTheme.getResponsiveHeight(300),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(13)),
          image: DecorationImage(
              image: NetworkImage(imagePath ?? ''), fit: BoxFit.cover)),
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

  Widget _getSizedBox(AppThemeState _appTheme,
      {double width = 0.0, double height = 0.0}) {
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
        AppComponentBase.getInstance()
            ?.getDbHelper()
            .insertCartDetails(product!);
      },
    );
  }

  Widget _getTitleCartIcon(AppThemeState _appTheme) {
    return Container(
      margin: EdgeInsets.only(right: _appTheme.getResponsiveWidth(20)),
      child: InkWell(
        child: SvgPicture.asset(
          SVGPath.cartIcon,
          color: _appTheme.whiteColor,
          width: _appTheme.getResponsiveWidth(30),
          height: _appTheme.getResponsiveHeight(30),
        ),
        onTap: () {
          Navigator.of(context, rootNavigator: true)
              .pushNamed(RouteName.cartPage);
        },
      ),
    );
  }

  Widget _getEmptyTextField(AppThemeState _appTheme) {
    return Center(
      child: Text(
        StringConstants.productIsNotAvailable,
        style: _appTheme.customTextStyle(
            fontSize: 40,
            fontWeightType: FontWeightType.regular,
            fontFamilyType: FontFamilyType.poppins,
            color: _appTheme.greyColor),
      ),
    );
  }
}
