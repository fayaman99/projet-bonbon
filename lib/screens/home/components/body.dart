import 'package:flutter/material.dart';
import 'package:online_food_ordering_web/model.dart/responsive.dart';
import 'package:online_food_ordering_web/screens/home/components/product.dart';
import 'package:online_food_ordering_web/screens/home/components/services_card.dart';

import '../../../constants.dart';

class BodyContainer extends StatelessWidget {
  BodyContainer({Key? key, required this.isIndex}) : super(key: key);
  bool isIndex;

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;

    rowCard() {
      int reponse = 1;
      if (_size.width >= 940) reponse = 5;
      if (_size.width < 940 && _size.width >= 870) reponse = 4;
      if (_size.width < 870 && _size.width >= 690) reponse = 3;
      if (_size.width < 690 && _size.width >= 400) reponse = 2;
      if (_size.width < 400) reponse = 1;
      return reponse;
    }

    colCard() {
      double reponse = 1;
      if (_size.width >= 1190) reponse = 0.80;
      if (_size.width < 1190 && _size.width >= 1040) reponse = 0.7;
      if (_size.width < 1190 && _size.width >= 1040) reponse = 0.7;
      if (_size.width < 1040 && _size.width >= 940) reponse = 0.63;
      if (_size.width < 940 && _size.width >= 880) reponse = 0.73;
      if (_size.width < 880 && _size.width >= 870) reponse = 0.7;
      if (_size.width < 870 && _size.width >= 795) reponse = 0.9;
      if (_size.width < 795 && _size.width >= 720) reponse = 0.82;
      if (_size.width < 720 && _size.width >= 690) reponse = 0.78;
      if (_size.width < 690 && _size.width >= 630) reponse = 1.1;
      if (_size.width < 630 && _size.width >= 510) reponse = 1;
      if (_size.width < 510 && _size.width >= 450) reponse = 0.9;
      if (_size.width < 450 && _size.width >= 400) reponse = 0.8;
      if (_size.width < 400 && _size.width >= 320) reponse = 1;
      if (_size.width < 320 && _size.width >= 290) reponse = 0.9;
      if (_size.width < 290 && _size.width >= 250) reponse = 0.75;
      if (_size.width < 250) reponse = 0.7;
      return reponse;
    }

    return Container(
      padding: const EdgeInsets.all(kPadding),
      constraints: const BoxConstraints(maxWidth: kMaxWidth),
      child: Column(
        children: <Widget>[
          Responsive(
            desktop: ProductCard(
              crossAxiscount: rowCard(),
              aspectRatio: colCard(),
              isIndex: isIndex,
            ),
            tablet: ProductCard(
              crossAxiscount: rowCard(),
              aspectRatio: colCard(),
              isIndex: isIndex,
            ),
            mobile: ProductCard(
              crossAxiscount: rowCard(),
              aspectRatio: colCard(),
              isIndex: isIndex,
            ),
          ),
          const SizedBox(
            height: 40,
          ),
        ],
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  ProductCard(
      {Key? key,
      required this.crossAxiscount,
      this.aspectRatio = 1.1,
      required this.isIndex})
      : super(key: key);
  final int crossAxiscount;
  final double aspectRatio;
  bool isIndex;
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxiscount,
        childAspectRatio: aspectRatio,
      ),
      itemBuilder: (context, index) => Products(
        product: listeActuelProduit[index],
        colone: crossAxiscount,
      ),
      itemCount: isIndex
          ? (listeActuelProduit.length > 8 ? 8 : listeActuelProduit.length)
          : (listeActuelProduit.length > 60 ? 60 : listeActuelProduit.length),
    );
  }
}
