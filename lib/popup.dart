import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:online_food_ordering_web/constants.dart';

// ignore: non_constant_identifier_names
AddVenteDialog(BuildContext context, idProduit) {
  TextEditingController quantite = TextEditingController();
  TextEditingController prixTotal = TextEditingController();

  List newList = [];
  newList = OldListProduit.where((o) => o["id_produit"] == idProduit).toList();

  final index0 =
      listeCommande.indexWhere((element) => element["id_produit"] == idProduit);

  if (index0 == -1) {
    quantite.text = "1";
    prixTotal.text =
        toMonetaire(newList[0]["prix_unitaire_ht"]).toString() + UniteMonetaire;
  } else {
    quantite.text = listeCommande[index0]["nombre_achat"];
    var prix = double.parse(newList[0]["prix_unitaire_ht"]) *
        double.parse(listeCommande[index0]["nombre_achat"]);
    prixTotal.text = toMonetaire(prix.toString()) + UniteMonetaire;
  }

  Widget cancelButton = (MediaQuery.of(context).size.width >= 300)
      ? ElevatedButton(
          child: const Text(
            "Annuller",
            style: TextStyle(color: Colors.black),
          ),
          style: ElevatedButton.styleFrom(
              backgroundColor: ColorBtnAnnule, elevation: 10),
          onPressed: () {
            Navigator.of(context).pop(); // dismiss dialog
          },
        )
      : ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 255, 255, 255),
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(5),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(
                Icons.cancel,
                color: Color.fromARGB(255, 255, 0, 0),
                size: 18,
              ),
            ],
          ),
        );
  Widget continueButton = (MediaQuery.of(context).size.width >= 300)
      ? ElevatedButton(
          child: const Text(
            "Ajouter au panier",
            style: TextStyle(color: Colors.black),
          ),
          style: ElevatedButton.styleFrom(
              backgroundColor: kPrimaryColor, elevation: 10),
          onPressed: () {
            final index1 = listeCommande
                .indexWhere((element) => element["id_produit"] == idProduit);
            if (index1 != -1) {
              var nomnreAchat =
                  int.parse(listeCommande[index1]["nombre_achat"]);
              // ignore: unnecessary_type_check
              assert(nomnreAchat is int);
              listeCommande[index1]["nombre_achat"] = quantite.text;
            } else {
              final index2 = listeActuelProduit
                  .indexWhere((element) => element["id_produit"] == idProduit);
              if (index2 != -1) {
                listeActuelProduit[index2]["nombre_achat"] = quantite.text;
                listeCommande.add(listeActuelProduit[index2]);
              }
            }
            Navigator.of(context).pop();
          },
        )
      : ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 255, 255, 255),
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(5),
          ),
          onPressed: () {
            final index1 = listeCommande
                .indexWhere((element) => element["id_produit"] == idProduit);
            if (index1 != -1) {
              var nomnreAchat =
                  int.parse(listeCommande[index1]["nombre_achat"]);
              // ignore: unnecessary_type_check
              assert(nomnreAchat is int);
              listeCommande[index1]["nombre_achat"] = quantite.text;
            } else {
              final index2 = listeActuelProduit
                  .indexWhere((element) => element["id_produit"] == idProduit);
              if (index2 != -1) {
                listeActuelProduit[index2]["nombre_achat"] = quantite.text;
                listeCommande.add(listeActuelProduit[index2]);
              }
            }
            Navigator.of(context).pop();
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(
                Icons.add,
                color: Color.fromARGB(255, 47, 0, 255),
                size: 18,
              ),
            ],
          ),
        );

  AlertDialog alert = AlertDialog(
    // title: const Center(
    //   child: Text(
    //     "Commande",
    //     style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
    //   ),
    // ),
    content: SizedBox(
      width: MediaQuery.of(context).size.width > 800
          ? MediaQuery.of(context).size.width * 0.6
          : MediaQuery.of(context).size.width * 0.5,
      child: SingleChildScrollView(
        child: Column(
          children: [
            if (MediaQuery.of(context).size.width >= 600)
              SizedBox(
                child: Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 20,
                    ),
                    Image(
                      image: NetworkImage(newList[0]['image_produit']),
                      height: MediaQuery.of(context).size.height * 0.4,
                      width: MediaQuery.of(context).size.width / 6,
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Column(
                      children: [
                        const SizedBox(
                          height: 5,
                        ),
                        Text(newList[0]["libelle_familles"]),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          newList[0]["libelle_produit"],
                          style: TextStyle(
                              fontSize: fontResponsive(
                                  MediaQuery.of(context).size.width, 18),
                              fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text("Prix : " + prixTotal.text),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(newList[0]["description"]),
                      ],
                    ),
                    const SizedBox(
                      width: 70,
                    ),
                    Column(
                      children: [
                        const Text("Total HT : "),
                        const SizedBox(
                          width: 5,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 6,
                          child: TextFormField(
                            enabled: false,
                            onChanged: (value) {},
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            controller: prixTotal,
                            decoration: const InputDecoration(
                                border: UnderlineInputBorder(),
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 5)),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 6,
                          child: TextFormField(
                            onChanged: (value) {
                              var prix =
                                  double.parse(newList[0]["prix_unitaire_ht"]) *
                                      double.parse(value);
                              prixTotal.text =
                                  toMonetaire(prix.toString()) + UniteMonetaire;
                            },
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            controller: quantite,
                            decoration: const InputDecoration(
                                border: UnderlineInputBorder(),
                                label: Text(
                                  "Quantité",
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.blue),
                                ),
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 5)),
                          ),
                        )
                      ],
                    ),

                    // const SizedBox(
                    //   width: 20,
                    // ),
                    // Expanded(
                    //   child: Padding(
                    //     padding: const EdgeInsets.symmetric(
                    //         horizontal: 0, vertical: 0),
                    //     child: Container(
                    //       width: 5,
                    //       child:
                    // TextFormField(
                    //         onChanged: (value) {
                    //           var prix =
                    //               double.parse(newList[0]["prix_unitaire_ht"]) *
                    //                   double.parse(value);
                    //           prixTotal.text =
                    //               toMonetaire(prix.toString()) + UniteMonetaire;
                    //         },
                    //         keyboardType: TextInputType.number,
                    //         inputFormatters: [
                    //           FilteringTextInputFormatter.digitsOnly
                    //         ],
                    //         controller: quantite,
                    //         decoration: const InputDecoration(
                    //             border: UnderlineInputBorder(),
                    //             label: Text(
                    //               "Quantité",
                    //               style: TextStyle(
                    //                   fontSize: 18, color: Colors.blue),
                    //             ),
                    //             contentPadding:
                    //                 EdgeInsets.symmetric(vertical: 5)),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            if (MediaQuery.of(context).size.width < 600)
              Column(
                children: [
                  Image(
                    image: NetworkImage(newList[0]['image_produit']),
                    height: 70,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    newList[0]["libelle_produit"],
                    style: TextStyle(
                        fontSize: fontResponsive(
                            MediaQuery.of(context).size.width, 18)),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    height: 18,
                    child: TextFormField(
                      onChanged: (value) {
                        var prix =
                            double.parse(newList[0]["prix_unitaire_ht"]) *
                                double.parse(value);
                        prixTotal.text =
                            toMonetaire(prix.toString()) + UniteMonetaire;
                      },
                      style: TextStyle(fontSize: 12),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      controller: quantite,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        // contentPadding: EdgeInsets.symmetric(vertical: 0)
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    height: 18,
                    child: TextFormField(
                      enabled: false,
                      onChanged: (value) {},
                      style: TextStyle(fontSize: 12),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      controller: prixTotal,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              )
          ],
        ),
      ),
    ),
    actions: [
      if (MediaQuery.of(context).size.width <= 300)
        Row(
          children: [
            cancelButton,
            SizedBox(
              width: (MediaQuery.of(context).size.width >= 240 &&
                      MediaQuery.of(context).size.width < 260)
                  ? 24
                  : 40,
            ),
            continueButton,
          ],
        ),
      if (MediaQuery.of(context).size.width > 300) cancelButton,
      if (MediaQuery.of(context).size.width > 300) continueButton,
      if (MediaQuery.of(context).size.width > 300)
        SizedBox(
          width: 30,
          height: 50,
        ),
    ],
  ); // show the dialog

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

reponseCommande(BuildContext context, msg, etat) {
  Widget cancelButton = ElevatedButton(
    child: const Text("Fermer"),
    onPressed: () {
      Navigator.of(context).pop(); // dismiss dialog
    },
  );

  AlertDialog alert = AlertDialog(
    content: SizedBox(
      width: 300,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              child: Row(
                children: [
                  if (etat)
                    const Expanded(
                      child: Icon(
                        Icons.check_circle,
                        color: Color.fromARGB(255, 0, 255, 26),
                        size: 60,
                      ),
                    ),
                  if (!etat)
                    const Expanded(
                      child: Icon(
                        Icons.cancel_rounded,
                        color: Color.fromARGB(255, 255, 0, 0),
                        size: 60,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: 250,
              child: Text(msg),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    ),
    actions: [
      cancelButton,
      // continueButton,
    ],
  ); // show the dialog

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

// ignore: non_constant_identifier_names
DetailCommande(BuildContext context, idCommande, myligne) {
  DataRow recentDataRow(ligne) {
    var prix = double.parse(ligne["prix_unitaire_ht"]) * ligne["quantite"];

    return DataRow(
      cells: [
        const DataCell(
          Image(
            image: AssetImage(
                "assets/images/chicken-pizza-with-bell-red-yellow-pepper.jpg"),
            // NetworkImage(liste_produit[index]['image_produit']),
            height: 40,
          ),
        ),
        DataCell(Text(ligne["libelle_produit"].toString())),
        DataCell(Text(prix.toString() + UniteMonetaire)),
        DataCell(Text(ligne["quantite"].toString()))
      ],
    );
  }

  Widget cancelButton = ElevatedButton(
    child: const Text("Fermer"),
    onPressed: () {
      Navigator.of(context).pop(); // dismiss dialog
    },
  );

  AlertDialog alert = AlertDialog(
    // title: const Center(
    //   child: Text("Detail du commande"),
    // ),
    content: SizedBox(
      width: 650,
      child: SingleChildScrollView(
        child: MediaQuery.of(context).size.width > 500
            ? SizedBox(
                width: double.infinity,
                child: DataTable(
                  horizontalMargin: 0,
                  columnSpacing: kPadding,
                  columns: const [
                    DataColumn(
                      label: Text("Image"),
                    ),
                    DataColumn(
                      label: Text("Nom"),
                    ),
                    DataColumn(
                      label: Text("Prix total"),
                    ),
                    DataColumn(
                      label: Text("Quantité"),
                    ),
                  ],
                  rows: List.generate(
                    myligne.length,
                    (index) => recentDataRow(myligne[index]),
                  ),
                ),
              )
            : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  horizontalMargin: 0,
                  columnSpacing: kPadding,
                  columns: const [
                    DataColumn(
                      label: Text("Image"),
                    ),
                    DataColumn(
                      label: Text("Nom"),
                    ),
                    DataColumn(
                      label: Text("Prix total"),
                    ),
                    DataColumn(
                      label: Text("Quantité"),
                    ),
                  ],
                  rows: List.generate(
                    myligne.length,
                    (index) => recentDataRow(myligne[index]),
                  ),
                ),
              ),
      ),
    ),
    actions: [
      cancelButton,
      // continueButton,
    ],
  ); // show the dialog

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

Future<bool> AnnullationConfirm(BuildContext context, msg, etat) async {
  var myb = false;
  Widget cancelButton = ElevatedButton(
    child: const Text("Non"),
    onPressed: () {
      myb = false;
      Navigator.of(context).pop(); // dismiss dialog
    },
  );

  Widget confirmButton = ElevatedButton(
    child: const Text("Oui"),
    onPressed: () {
      myb = true;
      Navigator.of(context).pop();
    },
  );

  AlertDialog alert = AlertDialog(
    content: SizedBox(
      width: 300,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              child: Row(
                children: [
                  if (etat)
                    const Expanded(
                      child: Icon(
                        Icons.check_circle,
                        color: Color.fromARGB(255, 0, 255, 26),
                        size: 60,
                      ),
                    ),
                  if (!etat)
                    const Expanded(
                      child: Icon(
                        Icons.cancel_rounded,
                        color: Color.fromARGB(255, 255, 0, 0),
                        size: 60,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: 250,
              child: Text(msg),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    ),
    actions: [
      cancelButton,
      confirmButton,
    ],
  ); // show the dialog

  await showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
      barrierDismissible: false);
  return myb;
}

Future<bool> Confirmation(BuildContext context, etat) async {
  var myb = false;
  Widget cancelButton = ElevatedButton(
    child: const Text("Non"),
    onPressed: () {
      myb = false;
      Navigator.of(context).pop(); // dismiss dialog
    },
  );

  Widget confirmButton = ElevatedButton(
    child: const Text("Oui"),
    onPressed: () {
      myb = true;
      Navigator.of(context).pop();
    },
  );

  AlertDialog alert = AlertDialog(
    content: SizedBox(
      width: 300,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              child: Row(
                children: [
                  if (etat)
                    const Expanded(
                      child: Icon(
                        Icons.check_circle,
                        color: Color.fromARGB(255, 0, 255, 26),
                        size: 60,
                      ),
                    ),
                  if (!etat)
                    const Expanded(
                      child: Icon(
                        Icons.cancel_rounded,
                        color: Color.fromARGB(255, 255, 0, 0),
                        size: 60,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              "Ce commande sera livrée à ",
              style: TextStyle(
                  fontSize:
                      fontResponsive(MediaQuery.of(context).size.width, 24),
                  fontWeight: FontWeight.w700),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                const Flexible(
                  child: Text("Mr(Mme) : "),
                ),
                Flexible(
                  child: Text(
                    Connection[0]["nom"] + " " + Connection[0]["prenom"],
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Flexible(
                  child: Text("Contact : "),
                ),
                Flexible(
                  child: Text(
                    Connection[0]["contact"],
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Flexible(
                  child: Text("Pays : "),
                ),
                Flexible(
                  child: Text(
                    Connection[0]["pays"],
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Flexible(
                  child: Text("Province / Ville : "),
                ),
                Flexible(
                  child: Text(
                    Connection[0]["province"] + " / " + Connection[0]["ville"],
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Flexible(
                  child: Text("Adresse : "),
                ),
                Flexible(
                  child: Text(
                    Connection[0]["adresse"],
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Flexible(
                  child: Text("Voie / Complement : "),
                ),
                Flexible(
                  child: Text(
                    Connection[0]["voie"] + " / " + Connection[0]["complement"],
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Text(totalTTC_HT(listeCommande)),
            Text("ou Choisir un autre adresse"),
            const SizedBox(height: 20),
          ],
        ),
      ),
    ),
    actions: [
      cancelButton,
      confirmButton,
    ],
  ); // show the dialog

  await showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
      barrierDismissible: false);
  return myb;
}
