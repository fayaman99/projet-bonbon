import 'dart:convert';

import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../popup.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as ImageProcess;

class Products extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final product;

  const Products({Key? key, this.product, required this.colone})
      : super(key: key);
  final int colone;

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size.width;
    heigthImageResponsive() {
      double reponse = 1;
      if (_size >= 850) reponse = 100;
      if (_size < 850 && _size >= 690) reponse = 90;
      if (_size < 690 && _size >= 620) reponse = 80;
      if (_size < 620 && _size >= 600) reponse = 75;
      if (_size < 600 && _size >= 400) reponse = 50;
      if (_size < 400 && _size > 380) reponse = 150;
      if (_size <= 380 && _size >= 306) reponse = 100;
      if (_size < 306 && _size >= 299) reponse = 80;
      if (_size < 299) reponse = 100;
      // if (_size > 690) reponse = 100;
      // if (_size > 690) reponse = 100;
      return reponse;
    }

    widthTexteResponsive() {
      double reponse = 1;
      if (_size >= 870) reponse = 160;
      if (_size < 870 && _size >= 850) reponse = 180;
      if (_size < 850 && _size >= 800) reponse = 160;
      if (_size < 800 && _size >= 750) reponse = 140;
      if (_size < 750 && _size >= 720) reponse = 130;
      if (_size < 720 && _size >= 690) reponse = 135;
      if (_size < 690 && _size >= 670) reponse = 230;
      if (_size < 670 && _size >= 630) reponse = 210;
      if (_size < 630 && _size >= 580) reponse = 190;
      if (_size < 580 && _size >= 550) reponse = 170;
      if (_size < 550 && _size >= 495) reponse = 150;
      if (_size < 495 && _size >= 455) reponse = 130;
      if (_size < 455 && _size >= 430) reponse = 110;
      if (_size < 430 && _size >= 400) reponse = 95;
      if (_size < 400 && _size >= 375) reponse = 250;
      if (_size < 375 && _size >= 330) reponse = 210;
      if (_size < 330 && _size >= 280) reponse = 160;
      if (_size < 280 && _size >= 210) reponse = 120;

      if (_size < 240) reponse = 100;

      return reponse;
    }

    @override
    void initState() {
      // super.initState();
    }
    return Padding(
      padding: const EdgeInsets.all(kPadding / 2),
      child: Material(
        elevation: 30,
        color: Color.fromARGB(255, 255, 245, 252),
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.all(5.0),
          width: 100,
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              ClipRRect(
                child: Image.memory(
                  base64.decode(product["image_produit"].split(',').last),
                  height: heigthImageResponsive(),
                ),
                // Image.asset(
                //   product["image_produit"],
                // height: heigthImageResponsive(),
                // ),
              ),
              const SizedBox(
                height: 20,
              ),
              Column(
                children: [
                  Text(
                    toMonetaire(product["prix_unitaire_ht"]).toString() +
                        UniteMonetaire,
                    style: TextStyle(
                        fontSize: fontResponsive(
                            MediaQuery.of(context).size.width, 18),
                        fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: widthTexteResponsive(),
                    height: 55,
                    child: Text(
                      product["libelle_produit"],
                      style: TextStyle(
                          fontSize: fontResponsive(
                              MediaQuery.of(context).size.width, 12),
                          color: Colors.black,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryColor, elevation: 10),
                    onPressed: () async {
                      final index1 = listeCommande.indexWhere((element) =>
                          element["id_produit"] == product["id_produit"]);
                      if (index1 == -1) {
                        final index2 = listeActuelProduit.indexWhere(
                            (element) =>
                                element["id_produit"] == product["id_produit"]);
                        if (index2 != -1) {
                          listeCommande.add(listeActuelProduit[index2]);
                        }
                      }

                      // bool _checksCompleted =
                      //     await AddVenteDialog(context, product["id_produit"]);
                      // if (_checksCompleted) {}
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Ajouter au panier",
                          style: TextStyle(
                              fontSize: fontResponsive(
                                  MediaQuery.of(context).size.width, 13),
                              color: Color.fromARGB(255, 0, 0, 0),
                              fontWeight: FontWeight.w700),
                        ),
                        const Icon(
                          Icons.add_shopping_cart_sharp,
                          color: Color.fromARGB(255, 0, 0, 0),
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
