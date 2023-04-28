// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:online_food_ordering_web/constants.dart';
import '../../popup.dart';
import 'components/footer.dart';
import 'components/header_container.dart';
import 'components/menu.dart';
import 'package:http/http.dart' as http;

class DetailAchatScreen extends StatefulWidget {
  const DetailAchatScreen({Key? key}) : super(key: key);
  @override
  _DetailAchatScreenState createState() => _DetailAchatScreenState();
}

class _DetailAchatScreenState extends State<DetailAchatScreen> {
  Future<void> SendMyShop(dataEnvoyer) async {
    try {
      List detailAdd = [];
      var responseAdd = await http.post(Uri.parse(url_add),
          headers: {
            "content-type": "application/json",
            "id": Connection[0]["id"]
          },
          body: jsonEncode({
            "base_name": base_commande,
            "etat": editCommande ? 1 : 0,
            "id_commande": id_commmande_modif,
            "data": dataEnvoyer
          }));

      if (responseAdd.statusCode == 200) {
        detailAdd = json.decode(responseAdd.body);

        bool stat = detailAdd[0]["statut"] == "1" ? true : false;
        reponseCommande(context, detailAdd[0]["msg"], stat);
        if (stat) {
          setState(() {
            listeCommande = [];
            editCommande = false;
            myNavigator(context, "1");
          });
        }
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> getAllAdresse(dataEnvoyer) async {
    try {
      List detailAdd = [];
      var responseAdd = await http.post(Uri.parse(url_get),
          headers: {
            "content-type": "application/json",
            "id": Connection[0]["id"]
          },
          body: jsonEncode({
            // "base_name": base_adresse,
          }));

      if (responseAdd.statusCode == 200) {
        detailAdd = json.decode(responseAdd.body);

        bool stat = detailAdd[0]["statut"] == "1" ? true : false;
        reponseCommande(context, detailAdd[0]["msg"], stat);
        if (stat) {
          setState(() {
            listeCommande = [];
            editCommande = false;
            myNavigator(context, "1");
          });
        }
      }
    } catch (e) {
      print(e);
    }
  }

  List HT_TTC = [];
  TextEditingController prixTTC = TextEditingController();
  TextEditingController prixHT = TextEditingController();
  whereProduit(String input) {}
  @override
  void initState() {
    super.initState();
    HT_TTC = totalTTC_HT(listeCommande);
    prixTTC.text = HT_TTC[0]["TTC"];
    prixHT.text = HT_TTC[0]["HT"];
  }

  Widget build(BuildContext context) {
    DataRow recentDataRow(Commande) {
      TextEditingController quantite = TextEditingController();
      TextEditingController prixTotal = TextEditingController();

      quantite.text = Commande["nombre_achat"].toString();
      prixTotal.text = (double.parse(Commande["prix_unitaire_ht"]) *
                  double.parse(quantite.text))
              .toString() +
          UniteMonetaire;
      return DataRow(
        cells: [
          DataCell(
            Center(
              child: Image.memory(
                base64.decode(Commande["image_produit"].split(',').last),
                height: 50,
                width: 50,
              ),
            ),
          ),
          DataCell(Text(Commande["libelle_produit"])),
          DataCell(
            TextFormField(
              onChanged: (value) {
                prixTotal.text = (double.parse(Commande["prix_unitaire_ht"]) *
                            double.parse(value))
                        .toString() +
                    UniteMonetaire;

                final index0 = listeCommande.indexWhere((element) =>
                    element["id_produit"] == Commande["id_produit"]);

                if (index0 != -1) {
                  setState(() {
                    listeCommande[index0]["nombre_achat"] = value;
                    HT_TTC = totalTTC_HT(listeCommande);
                    prixTTC.text = HT_TTC[0]["TTC"];
                    prixHT.text = HT_TTC[0]["HT"];
                  });
                }
              },
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              controller: quantite,
              decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(vertical: 5)),
            ),
          ),
          DataCell(
            TextFormField(
              enabled: false,
              onChanged: (value) {},
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              controller: prixTotal,
              decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(vertical: 5)),
            ),
          ),
          DataCell(
            SizedBox(
              height: 50,
              width: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 255, 255, 255),
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(5),
                ),
                onPressed: () {
                  final index0 = listeCommande.indexWhere((element) =>
                      element["id_produit"] == Commande["id_produit"]);

                  if (index0 != -1) {
                    setState(() {
                      listeCommande.remove(listeCommande[index0]);
                      HT_TTC = totalTTC_HT(listeCommande);
                      prixTTC.text = HT_TTC[0]["TTC"];
                      prixHT.text = HT_TTC[0]["HT"];
                    });
                  }
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(
                      Icons.delete,
                      color: Color.fromARGB(255, 255, 0, 0),
                      size: 18,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    }

    return Scaffold(
      drawer: MyDrawerMenu(),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              HeaderContainer(isIndex: false, onChange: whereProduit),
              SizedBox(
                height: 20,
              ),
              Center(
                child: Text(
                  "Mes achats",
                  style: TextStyle(
                      fontSize:
                          fontResponsive(MediaQuery.of(context).size.width, 18),
                      fontWeight: FontWeight.bold),
                ),
              ),
              Row(
                children: <Widget>[
                  SizedBox(
                    width: 20,
                  ),
                  if (MediaQuery.of(context).size.width < 500)
                    Flexible(
                        child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        // headingRowColor: MaterialStateColor.resolveWith(
                        //     (states) => Colors.blue),
                        horizontalMargin: 0,
                        columnSpacing:
                            (MediaQuery.of(context).size.width / 10) * 0.5,
                        dataRowHeight: 80,
                        columns: const [
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                'Image',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                'Nom',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                'Quantité',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                'Montant',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(" "),
                          ),
                        ],
                        rows: List.generate(
                          listeCommande.length,
                          (index) => recentDataRow(listeCommande[index]),
                        ),
                      ),
                    )),
                  if (MediaQuery.of(context).size.width > 500)
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        child: SizedBox(
                          width: double.infinity,
                          child: Card(
                            elevation: 10,
                            child: DataTable(
                              border: TableBorder.all(width: 0.001),
                              // headingRowColor: MaterialStateColor.resolveWith(
                              //     (states) =>
                              //         Color.fromARGB(255, 228, 228, 228)),
                              horizontalMargin: 0,
                              columnSpacing:
                                  (MediaQuery.of(context).size.width / 10) *
                                      0.5,
                              dataRowHeight: 80,
                              columns: const [
                                DataColumn(
                                  label: Expanded(
                                    child: Text(
                                      'Image',
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: Expanded(
                                    child: Text(
                                      'Nom',
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: Expanded(
                                    child: Text(
                                      'Quantité',
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: Expanded(
                                    child: Text(
                                      'Montant',
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(" "),
                                ),
                              ],
                              rows: List.generate(
                                listeCommande.length,
                                (index) => recentDataRow(listeCommande[index]),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  Card(
                    elevation: 10,
                    child: SizedBox(
                      width: 400,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Total HT:" + prixHT.text + UniteMonetaire,
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Total TTC:" + prixTTC.text + UniteMonetaire,
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 20,
                              ),
                              Flexible(
                                child: Center(
                                    child: Container(
                                  // height: 30,
                                  decoration: BoxDecoration(
                                    color: kPrimaryColor,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Color.fromARGB(255, 14, 111, 106),
                                    ),
                                    onPressed: () async {
                                      if (Connection[0]["statut"] == true) {
                                        bool _checksCompleted =
                                            await Confirmation(context, true);
                                        if (_checksCompleted) {
                                          SendMyShop(listeCommande);
                                        }
                                      } else {
                                        redirection = "5";
                                        myNavigator(context, "0");
                                      }
                                    },
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: const [
                                        Text(
                                          "Commander",
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 255, 255, 255)),
                                        ),
                                        Icon(
                                          Icons.check_circle,
                                          color: Color.fromARGB(
                                              255, 255, 255, 255),
                                          size: 22,
                                        ),
                                      ],
                                    ),
                                  ),
                                )),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 20,
                              ),
                              Flexible(
                                child: Center(
                                    child: Container(
                                  // height: 30,
                                  decoration: BoxDecoration(
                                    color: kPrimaryColor,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: ColorBtnAnnule,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        editCommande = false;
                                        listeCommande = [];
                                        HT_TTC = totalTTC_HT(listeCommande);
                                        prixTTC.text = HT_TTC[0]["TTC"];
                                        prixHT.text = HT_TTC[0]["HT"];
                                      });
                                    },
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: const [
                                        Text(
                                          "Anuller",
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 255, 255, 255)),
                                        ),
                                      ],
                                    ),
                                  ),
                                )),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              // Row(
              //   children: [
              //     SizedBox(
              //       width: 20,
              //     ),
              //     Flexible(
              //       child: Center(
              //           child: Container(
              //         // height: 30,
              //         decoration: BoxDecoration(
              //           color: kPrimaryColor,
              //           borderRadius: BorderRadius.circular(8.0),
              //         ),
              //         child: ElevatedButton(
              //           style: ElevatedButton.styleFrom(
              //             backgroundColor: Color.fromARGB(255, 14, 111, 106),
              //           ),
              //           onPressed: () async {
              //             if (Connection[0]["statut"] == true) {
              //               bool _checksCompleted =
              //                   await Confirmation(context, true);
              //               if (_checksCompleted) {
              //                 SendMyShop(listeCommande);
              //               }
              //             } else {
              //               redirection = "5";
              //               myNavigator(context, "0");
              //             }
              //           },
              //           child: Row(
              //             mainAxisSize: MainAxisSize.min,
              //             children: const [
              //               Text(
              //                 "Envoyer la commande",
              //                 style: TextStyle(
              //                     color: Color.fromARGB(255, 255, 255, 255)),
              //               ),
              //               Icon(
              //                 Icons.check_circle,
              //                 color: Color.fromARGB(255, 255, 255, 255),
              //                 size: 22,
              //               ),
              //             ],
              //           ),
              //         ),
              //       )),
              //     ),
              //   ],
              // ),

              SizedBox(
                height: 20,
              ),
              Footer(),
            ],
          ),
        ),
      ),
    );
  }
}
