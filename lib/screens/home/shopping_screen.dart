// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:online_food_ordering_web/constants.dart';
import '../../model.dart/responsive.dart';
import 'components/body.dart';
import 'components/footer.dart';
import 'components/header_container.dart';
import 'components/menu.dart';
import 'components/product.dart';

class SoppingScreen extends StatefulWidget {
  const SoppingScreen({Key? key}) : super(key: key);
  @override
  _SoppingScreenState createState() => _SoppingScreenState();
}

class _SoppingScreenState extends State<SoppingScreen> {
  Future<void> getProduit() async {
    try {
      var responseProd = await http.post(Uri.parse(url_get),
          headers: {"content-type": "application/json"},
          body: jsonEncode({"base_name": base_produit}));
      if (responseProd.statusCode == 200) {
        // var cookie = responseProd.headers['set-cookie'];
        // print(responseProd.headers);
        setState(() {
          OldListProduit = json.decode(responseProd.body);
          listeActuelProduit = OldListProduit;
        });
      }
    } catch (e) {
      print(e);
    }
    // try {
    //   var responseProd = await http.get(
    //       Uri.parse(
    //           "http://192.168.88.230/assiasweet/mes_donnes/images_produits/0u9tegvec0cuoaiai16gqe09ih9uzh61eqs410jc1vsbn1e20230408013916800.jpg"),
    //       headers: {
    //         "content-type": "application/json",
    //         'Access-Control-Allow-Origin': '*'
    //       });

    //   setState(() {
    //     OldListProduit = json.decode(responseProd.body);
    //     listeActuelProduit = OldListProduit;
    //   });
    // } catch (e) {
    //   print(e);
    // }
  }

  Future<void> getFamilles() async {
    try {
      var responseProd = await http.post(Uri.parse(url_get),
          headers: {"content-type": "application/json"},
          body: jsonEncode({"base_name": base_familles}));

      setState(() {
        listeFamilles = json.decode(responseProd.body);
        listeFamilleToArray(json.decode(responseProd.body));
      });
    } catch (e) {
      print(e);
    }
  }

  void _passedFunction(String input) {
    List newList = [];
    if (input == "tout") {
      newList = OldListProduit;
    } else {
      newList = OldListProduit.where((o) =>
              o["libelle_produit"].toLowerCase().contains(input.toLowerCase()))
          .toList();
    }
    setState(() {
      listeActuelProduit = newList;
    });
  }

  @override
  void initState() {
    super.initState();
    getProduit();
    getFamilles();
  }

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

    return Scaffold(
      drawer: MyDrawerMenu(),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              HeaderContainer(isIndex: false, onChange: _passedFunction),

              // if (MediaQuery.of(context).size.width < 480)
              //   DropdownSearch<String>(
              //     mode: Mode.MENU,
              //     showSelectedItems: true,
              //     items: listFamillesAray,
              //     onChanged: (value) {
              //       List newList = [];
              //       if (value != null) {
              //         if (value == "Tout") {
              //           newList = OldListProduit;
              //         } else {
              //           final index0 = listeFamilles.indexWhere(
              //               (element) => element["libelle_familles"] == value);
              //           if (index0 != -1) {
              //             newList = OldListProduit.where((o) =>
              //                 o["id_familles"] ==
              //                 listeFamilles[index0]["id_familles"]).toList();
              //           }
              //         }
              //       }

              //       setState(() {
              //         listeActuelProduit = newList;
              //       });
              //     },
              //     showSearchBox: true,
              //     searchFieldProps: TextFieldProps(
              //       cursorColor: Colors.blue,
              //     ),
              //   ),
              if (MediaQuery.of(context).size.width < 400)
                SizedBox(
                  height: 10,
                ),
              if (MediaQuery.of(context).size.width < 400)
                SizedBox(
                  width: MediaQuery.of(context).size.width - 40,
                  child: TextField(
                    onChanged: (value) {
                      List newList = OldListProduit.where((o) =>
                          o["libelle_produit"]
                              .toLowerCase()
                              .contains(value.toLowerCase())).toList();
                      setState(() {
                        listeActuelProduit = newList;
                      });
                    },
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(7.0)))),
                  ),
                ),
              // BodyContainer(
              //   isIndex: false,
              // ),
              Container(
                padding: const EdgeInsets.all(kPadding),
                constraints: const BoxConstraints(maxWidth: kMaxWidth),
                child: Column(
                  children: <Widget>[
                    Responsive(
                      desktop: ProductCard(
                        crossAxiscount: rowCard(),
                        aspectRatio: colCard(),
                      ),
                      tablet: ProductCard(
                        crossAxiscount: rowCard(),
                        aspectRatio: colCard(),
                      ),
                      mobile: ProductCard(
                        crossAxiscount: rowCard(),
                        aspectRatio: colCard(),
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                  ],
                ),
              ),
              // Row(
              //   children: [
              // Container(
              //   width: 180,
              //   child: Column(
              //     children: [Text("data"), Text("data1")],
              //   ),
              // ),
              //     BodyContainer(
              //       isIndex: false,
              //     ),
              //   ],
              // ),
              //footer
              SizedBox(
                height: 30,
              ),
              Footer(),
            ],
          ),
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  ProductCard({
    Key? key,
    required this.crossAxiscount,
    this.aspectRatio = 1.1,
  }) : super(key: key);
  final int crossAxiscount;
  final double aspectRatio;

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
      itemCount:
          listeActuelProduit.length > 60 ? 60 : listeActuelProduit.length,
    );
  }
}
