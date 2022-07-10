import 'package:flutter/material.dart';

import '../common/stringConstant.dart';
import '../common/widget/common_app_bar.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({Key? key}) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(
            MediaQuery
                .of(context)
                .size
                .width, AppBar().preferredSize.height),
        child: const CommonAppBar(
          title: StringConstants.shoppingMall,
          elevation: 0.2,
          isBackButtonVisible: false,
          centerTitle: true,
          actions: [],
        ),
      ),
    );
  }
}
