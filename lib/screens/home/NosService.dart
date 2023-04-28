// ignore_for_file: prefer_const_constructors
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:online_food_ordering_web/constants.dart';
import 'components/footer.dart';
import 'components/header_container.dart';
import 'components/menu.dart';
import 'components/services_card.dart';

class NosService extends StatefulWidget {
  const NosService({Key? key}) : super(key: key);

  @override
  _NosServiceState createState() => _NosServiceState();
}

class _NosServiceState extends State<NosService> {
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

  whereProduit(String input) {}
  @override
  void initState() {
    super.initState();
    getProduit();
    getFamilles();
  }

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
              const SizedBox(
                height: 20,
              ),
              Text("Nous offrons des divers services",
                  style: TextStyle(
                      fontSize:
                          fontResponsive(MediaQuery.of(context).size.width, 24),
                      color: const Color.fromARGB(137, 0, 0, 0),
                      fontWeight: FontWeight.w700)),
              const SizedBox(
                height: 20,
              ),
              ServicesCard(
                isIndex: false,
              ),
              //footer
              SizedBox(
                height: 30,
              ),
              Footer(),
              //now we make our website responsive
            ],
          ),
        ),
      ),
    );
  }
}
