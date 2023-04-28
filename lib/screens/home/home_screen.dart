// ignore_for_file: prefer_const_constructors
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:online_food_ordering_web/constants.dart';
import 'components/body.dart';
import 'components/footer.dart';
import 'components/header_container.dart';
import 'components/menu.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> getProduit() async {
    try {
      var responseProd = await http.post(Uri.parse(url_get),
          headers: {"content-type": "application/json"},
          body: jsonEncode({"base_name": base_produit}));

      setState(() {
        OldListProduit = json.decode(responseProd.body);
        listeActuelProduit = OldListProduit;
      });
    } catch (e) {
      print(e);
    }
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

  @override
  void initState() {
    super.initState();
    getProduit();
    getFamilles();
  }

  whereProduit(String input) {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawerMenu(),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              HeaderContainer(
                isIndex: true,
                onChange: whereProduit,
              ),
              BodyContainer(
                isIndex: true,
              ),
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
