import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:online_food_ordering_web/constants.dart';
import '../../model.dart/ListePays.dart';
import '../../popup.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'components/footer.dart';
import 'components/header_container.dart';
import 'components/menu.dart';
import 'package:http/http.dart' as http;

class MonCompteScreen extends StatefulWidget {
  const MonCompteScreen({Key? key}) : super(key: key);

  @override
  _MonCompteScreenState createState() => _MonCompteScreenState();
}

class _MonCompteScreenState extends State<MonCompteScreen> {
  final nomController = TextEditingController();
  final prenomController = TextEditingController();
  final contactController = TextEditingController();
  final emailController = TextEditingController();

  TextEditingController passwordActuelController = TextEditingController();
  final passwordNouveauController = TextEditingController();
  final passwordRetapController = TextEditingController();
  final MessageApresModification = TextEditingController();
  final MessageErrorController = TextEditingController();

  final PaysController = TextEditingController();
  final ProvinceController = TextEditingController();
  final CodePostalController = TextEditingController();
  final VilleController = TextEditingController();
  final VoieController = TextEditingController();
  final ComplementController = TextEditingController();
  final AdresseController = TextEditingController();

  bool passwordActuelVisible = false;
  bool passwordNouveauVisible = false;
  bool passwordRetapVisible = false;
  bool modification = false;
  bool codeConfirmation = false;
  bool enabledNewPass = false;

  Future<void> ModificationCompte() async {
    try {
      List detailInscription = [];
      var responseLogin = await http.post(Uri.parse(url_moncompte),
          headers: {
            "content-type": "application/json",
            "id": Connection[0]["id"]
          },
          body: jsonEncode({
            "nom": nomController.text,
            "prenom": prenomController.text,
            "contact": contactController.text,
            "email": emailController.text,
            "oldPassword": passwordActuelController.text,
            "newPassword1": passwordNouveauController.text,
            "newPassword2": passwordRetapController.text,
            "code_postal": CodePostalController.text,
            "pays": PaysController.text,
            "province": ProvinceController.text,
            "ville": VilleController.text,
            "voie": VoieController.text,
            "complement": ComplementController.text,
            "adresse": AdresseController.text
          }));

      if (responseLogin.statusCode == 200) {
        detailInscription = json.decode(responseLogin.body);
        if (detailInscription[0]["statut"] == "0") {
          reponseCommande(context, detailInscription[0]["msg"], false);
        } else {
          setState(() {
            modification = false;
            Connection[0]["statut"] = true;
            Connection[0]["nom"] = nomController.text;
            Connection[0]["prenom"] = prenomController.text;
            Connection[0]["nom_complet"] =
                nomController.text + " " + prenomController.text;
            Connection[0]["contact"] = contactController.text;
            Connection[0]["email"] = emailController.text;

            Connection[0]["voie"] = VoieController.text;
            Connection[0]["code_postal"] = CodePostalController.text;
            Connection[0]["province"] = ProvinceController.text;
            Connection[0]["ville"] = VilleController.text;
            Connection[0]["pays"] = PaysController.text;
            Connection[0]["adresse"] = AdresseController.text;
            Connection[0]["complement"] = ComplementController.text;
            MessageApresModification.text = detailInscription[0]["msg"];
          });
        }
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> getMesCommande() async {
    try {
      var responseProd = await http.post(Uri.parse(url_get),
          headers: {
            "content-type": "application/json",
            "id": Connection[0]["id"]
          },
          body: jsonEncode({"base_name": base_commande}));

      setState(() {
        ListeCommandesClient = json.decode(responseProd.body);
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> getDetailUnCommande(id_commande) async {
    try {
      var responseProd = await http.post(Uri.parse(url_get),
          headers: {
            "content-type": "application/json",
            "id": Connection[0]["id"]
          },
          body: jsonEncode(
              {"base_name": base_ligne_commande, "id": id_commande}));

      setState(() {
        LigneCommande = json.decode(responseProd.body);

        DetailCommande(context, id_commande, json.decode(responseProd.body));
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> modificationCommande(id_commande) async {
    try {
      var responseProd = await http.post(Uri.parse(url_get),
          headers: {
            "content-type": "application/json",
            "id": Connection[0]["id"]
          },
          body: jsonEncode(
              {"base_name": base_ligne_commande, "id": id_commande}));

      setState(() {
        listeCommande = json.decode(responseProd.body);
        myNavigator(context, '5');
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> AnnulCommande(id_commande) async {
    try {
      List detailAnnul = [];
      var responseAnnuleCommande = await http.post(Uri.parse(url_anule_command),
          headers: {
            "content-type": "application/json",
            "id": Connection[0]["id"]
          },
          body: jsonEncode({"id": id_commande}));

      if (responseAnnuleCommande.statusCode == 200) {
        detailAnnul = json.decode(responseAnnuleCommande.body);

        reponseCommande(context, detailAnnul[0]["msg"], false);
        if (detailAnnul[0]["statut"] == "1") {
          setState(() {
            getMesCommande();
          });
        }
      }
    } catch (e) {
      print(e);
    }
  }

  whereProduit(String input) {}
  @override
  void initState() {
    super.initState();
    getMesCommande();
    passwordActuelVisible = true;
    passwordNouveauVisible = true;
    passwordRetapVisible = true;
    enabledNewPass = false;

    nomController.text = Connection[0]["nom"];
    prenomController.text = Connection[0]["prenom"];
    contactController.text = Connection[0]["contact"];
    emailController.text = Connection[0]["email"];
    MessageApresModification.text = "";

    PaysController.text = Connection[0]["voie"];
    ProvinceController.text = Connection[0]["code_postal"];
    CodePostalController.text = Connection[0]["province"];
    VilleController.text = Connection[0]["ville"];
    VoieController.text = Connection[0]["pays"];
    ComplementController.text = Connection[0]["adresse"];
    AdresseController.text = Connection[0]["complement"];
  }

  Widget build(BuildContext context) {
    DataRow recentCommandeDataRow(Commande) {
      return DataRow(
        cells: [
          DataCell(Text(dateFormatter(Commande["date_saisie"]))),
          DataCell(Text(
              toMonetaire(Commande["total_ttc"]).toString() + UniteMonetaire)),
          DataCell(myStatutCommande(Commande["etat_commande"])),
          DataCell(Commande["etat_commande"] == 0
              ? Row(children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 10,
                      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                      shape: const CircleBorder(),
                      // padding: EdgeInsets.all(2),
                    ),
                    onPressed: () {
                      getDetailUnCommande(Commande["id_commandes"]);
                    },
                    child: Row(
                      // mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(
                          Icons.visibility,
                          color: Color.fromARGB(255, 0, 76, 27),
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 10,
                      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                      shape: const CircleBorder(),
                    ),
                    onPressed: () {
                      setState(() {
                        id_commmande_modif = Commande["id_commandes"];
                        editCommande = true;
                        modificationCommande(Commande["id_commandes"]);
                      });
                    },
                    child: Row(
                      children: const [
                        Icon(
                          Icons.edit,
                          color: Color.fromARGB(255, 25, 0, 255),
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 10,
                      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                      shape: const CircleBorder(),
                    ),
                    onPressed: () async {
                      bool _checksCompleted = await AnnullationConfirm(context,
                          "Vouliez vous annuler votre demande ?", false);
                      if (_checksCompleted) {
                        AnnulCommande(Commande["id_commandes"]);
                      }
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(
                          Icons.cancel,
                          color: Color.fromARGB(255, 255, 0, 0),
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ])
              : Row(children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 10,
                      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                      shape: const CircleBorder(),
                      // padding: EdgeInsets.all(2),
                    ),
                    onPressed: () {
                      getDetailUnCommande(Commande["id_commandes"]);
                    },
                    child: Row(
                      // mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(
                          Icons.visibility,
                          color: Color.fromARGB(255, 0, 76, 27),
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                  // ElevatedButton(
                  //   style: ElevatedButton.styleFrom(
                  //      elevation: 10,
                  //     backgroundColor: const Color.fromARGB(255, 31, 3, 159),
                  //   ),
                  //   onPressed: () {
                  //     getDetailUnCommande(Commande["id_commandes"]);
                  //   },
                  //   child: Row(
                  //     mainAxisSize: MainAxisSize.min,
                  //     children: const [
                  //       Text(
                  //         "Detail",
                  //         style: TextStyle(
                  //             color: Color.fromARGB(255, 255, 255, 255)),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                ])),
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
              HeaderContainer(
                isIndex: false,
                onChange: whereProduit,
              ),
              const SizedBox(
                height: 30,
              ),
              Text(
                MessageApresModification.text,
                style: const TextStyle(
                    color: Colors.green,
                    fontSize: 18,
                    fontWeight: FontWeight.w700),
              ),
              const SizedBox(
                height: 20,
              ),
              if (modification == true)
                Center(
                  child: Row(
                    children: <Widget>[
                      // MediaQuery.of(context).size.width > 700
                      // ? Flexible(
                      //     child: Row(
                      //     children: [
                      //       SizedBox(
                      //         width:
                      //             MediaQuery.of(context).size.width / 4,
                      //       ),
                      //       SizedBox(
                      //         width:
                      //             MediaQuery.of(context).size.width / 2,
                      //         child: Column(
                      //           children: [
                      //             Row(
                      //               children: [
                      //                 Flexible(
                      //                   child: TextField(
                      //                     controller: nomController,
                      //                     decoration: InputDecoration(
                      //                       label: const Text(
                      //                         "Nom",
                      //                         style:
                      //                             TextStyle(fontSize: 20),
                      //                       ),
                      //                       contentPadding:
                      //                           const EdgeInsets.only(
                      //                               left: 30),
                      //                       enabledBorder:
                      //                           OutlineInputBorder(
                      //                         borderSide:
                      //                             const BorderSide(
                      //                                 color:
                      //                                     Color.fromARGB(
                      //                                         255,
                      //                                         37,
                      //                                         50,
                      //                                         58)),
                      //                         borderRadius:
                      //                             BorderRadius.circular(
                      //                                 15),
                      //                       ),
                      //                       focusedBorder:
                      //                           OutlineInputBorder(
                      //                         borderSide:
                      //                             const BorderSide(
                      //                                 color:
                      //                                     Color.fromARGB(
                      //                                         255,
                      //                                         99,
                      //                                         152,
                      //                                         187)),
                      //                         borderRadius:
                      //                             BorderRadius.circular(
                      //                                 15),
                      //                       ),
                      //                     ),
                      //                   ),
                      //                 ),
                      //                 const SizedBox(
                      //                   width: 20,
                      //                 ),
                      //                 Flexible(
                      //                   child: TextField(
                      //                     controller: prenomController,
                      //                     decoration: InputDecoration(
                      //                       label: const Text("Prénom",
                      //                           style: TextStyle(
                      //                               fontSize: 20)),
                      //                       contentPadding:
                      //                           const EdgeInsets.only(
                      //                               left: 30),
                      //                       enabledBorder:
                      //                           OutlineInputBorder(
                      //                         borderSide:
                      //                             const BorderSide(
                      //                                 color:
                      //                                     Color.fromARGB(
                      //                                         255,
                      //                                         37,
                      //                                         50,
                      //                                         58)),
                      //                         borderRadius:
                      //                             BorderRadius.circular(
                      //                                 15),
                      //                       ),
                      //                       focusedBorder:
                      //                           OutlineInputBorder(
                      //                         borderSide:
                      //                             const BorderSide(
                      //                                 color:
                      //                                     Color.fromARGB(
                      //                                         255,
                      //                                         99,
                      //                                         152,
                      //                                         187)),
                      //                         borderRadius:
                      //                             BorderRadius.circular(
                      //                                 15),
                      //                       ),
                      //                     ),
                      //                   ),
                      //                 ),
                      //               ],
                      //             ),
                      //             const SizedBox(height: 20),
                      //             Row(
                      //               children: [
                      //                 Flexible(
                      //                   child: TextField(
                      //                     controller: contactController,
                      //                     decoration: InputDecoration(
                      //                       label: const Text("Contact",
                      //                           style: TextStyle(
                      //                               fontSize: 20)),
                      //                       contentPadding:
                      //                           const EdgeInsets.only(
                      //                               left: 30),
                      //                       enabledBorder:
                      //                           OutlineInputBorder(
                      //                         borderSide:
                      //                             const BorderSide(
                      //                                 color:
                      //                                     Color.fromARGB(
                      //                                         255,
                      //                                         37,
                      //                                         50,
                      //                                         58)),
                      //                         borderRadius:
                      //                             BorderRadius.circular(
                      //                                 15),
                      //                       ),
                      //                       focusedBorder:
                      //                           OutlineInputBorder(
                      //                         borderSide:
                      //                             const BorderSide(
                      //                                 color:
                      //                                     Color.fromARGB(
                      //                                         255,
                      //                                         99,
                      //                                         152,
                      //                                         187)),
                      //                         borderRadius:
                      //                             BorderRadius.circular(
                      //                                 15),
                      //                       ),
                      //                     ),
                      //                   ),
                      //                 ),
                      //                 const SizedBox(
                      //                   width: 20,
                      //                 ),
                      //                 Flexible(
                      //                   child: TextField(
                      //                     controller: emailController,
                      //                     decoration: InputDecoration(
                      //                       label: const Text("Email",
                      //                           style: TextStyle(
                      //                               fontSize: 20)),
                      //                       contentPadding:
                      //                           const EdgeInsets.only(
                      //                               left: 30),
                      //                       enabledBorder:
                      //                           OutlineInputBorder(
                      //                         borderSide:
                      //                             const BorderSide(
                      //                                 color:
                      //                                     Color.fromARGB(
                      //                                         255,
                      //                                         37,
                      //                                         50,
                      //                                         58)),
                      //                         borderRadius:
                      //                             BorderRadius.circular(
                      //                                 15),
                      //                       ),
                      //                       focusedBorder:
                      //                           OutlineInputBorder(
                      //                         borderSide:
                      //                             const BorderSide(
                      //                                 color:
                      //                                     Color.fromARGB(
                      //                                         255,
                      //                                         99,
                      //                                         152,
                      //                                         187)),
                      //                         borderRadius:
                      //                             BorderRadius.circular(
                      //                                 15),
                      //                       ),
                      //                     ),
                      //                   ),
                      //                 ),
                      //               ],
                      //             ),
                      //             const SizedBox(height: 20),
                      //             Row(
                      //               children: [
                      //                 Flexible(
                      //                   child: TextField(
                      //                     controller:
                      //                         passwordActuelController,
                      //                     onChanged: (value) {
                      //                       if (value.trim() != "") {
                      //                         setState(() {
                      //                           enabledNewPass = true;
                      //                         });
                      //                       } else {
                      //                         enabledNewPass = false;
                      //                         passwordNouveauController
                      //                             .text = "";
                      //                         passwordNouveauController
                      //                             .text = "";
                      //                       }
                      //                     },
                      //                     obscureText:
                      //                         passwordActuelVisible,
                      //                     decoration: InputDecoration(
                      //                       label: const Text(
                      //                           "Mot de passe actuel",
                      //                           style: TextStyle(
                      //                               fontSize: 20)),
                      //                       contentPadding:
                      //                           const EdgeInsets.only(
                      //                               left: 30),
                      //                       enabledBorder:
                      //                           OutlineInputBorder(
                      //                         borderSide:
                      //                             const BorderSide(
                      //                                 color:
                      //                                     Color.fromARGB(
                      //                                         255,
                      //                                         37,
                      //                                         50,
                      //                                         58)),
                      //                         borderRadius:
                      //                             BorderRadius.circular(
                      //                                 15),
                      //                       ),
                      //                       focusedBorder:
                      //                           OutlineInputBorder(
                      //                         borderSide:
                      //                             const BorderSide(
                      //                                 color:
                      //                                     Color.fromARGB(
                      //                                         255,
                      //                                         99,
                      //                                         152,
                      //                                         187)),
                      //                         borderRadius:
                      //                             BorderRadius.circular(
                      //                                 15),
                      //                       ),
                      //                       suffixIcon: IconButton(
                      //                         icon: Icon(
                      //                             passwordActuelVisible
                      //                                 ? Icons.visibility
                      //                                 : Icons
                      //                                     .visibility_off),
                      //                         onPressed: () {
                      //                           setState(
                      //                             () {
                      //                               passwordActuelVisible =
                      //                                   !passwordActuelVisible;
                      //                             },
                      //                           );
                      //                         },
                      //                       ),
                      //                     ),
                      //                     keyboardType: TextInputType
                      //                         .visiblePassword,
                      //                     textInputAction:
                      //                         TextInputAction.done,
                      //                   ),
                      //                 ),
                      //               ],
                      //             ),
                      //             const SizedBox(height: 20),
                      //             Row(
                      //               children: [
                      //                 Flexible(
                      //                   child: TextField(
                      //                     enabled: enabledNewPass,
                      //                     controller:
                      //                         passwordNouveauController,
                      //                     obscureText:
                      //                         passwordNouveauVisible,
                      //                     decoration: InputDecoration(
                      //                       label: Text(
                      //                           "Nouveau mot de passe",
                      //                           style: TextStyle(
                      //                               fontSize: 20)),
                      //                       contentPadding:
                      //                           EdgeInsets.only(left: 30),
                      //                       enabledBorder:
                      //                           OutlineInputBorder(
                      //                         borderSide: BorderSide(
                      //                             color: Color.fromARGB(
                      //                                 255, 37, 50, 58)),
                      //                         borderRadius:
                      //                             BorderRadius.circular(
                      //                                 15),
                      //                       ),
                      //                       focusedBorder:
                      //                           OutlineInputBorder(
                      //                         borderSide: BorderSide(
                      //                             color: Color.fromARGB(
                      //                                 255, 99, 152, 187)),
                      //                         borderRadius:
                      //                             BorderRadius.circular(
                      //                                 15),
                      //                       ),
                      //                       suffixIcon: IconButton(
                      //                         icon: Icon(
                      //                             passwordNouveauVisible
                      //                                 ? Icons.visibility
                      //                                 : Icons
                      //                                     .visibility_off),
                      //                         onPressed: () {
                      //                           setState(
                      //                             () {
                      //                               passwordNouveauVisible =
                      //                                   !passwordNouveauVisible;
                      //                             },
                      //                           );
                      //                         },
                      //                       ),
                      //                     ),
                      //                     keyboardType: TextInputType
                      //                         .visiblePassword,
                      //                     textInputAction:
                      //                         TextInputAction.done,
                      //                   ),
                      //                 ),
                      //               ],
                      //             ),
                      //             const SizedBox(height: 20),
                      //             Row(
                      //               children: [
                      //                 Flexible(
                      //                   child: TextField(
                      //                     enabled: enabledNewPass,
                      //                     controller:
                      //                         passwordRetapController,
                      //                     obscureText:
                      //                         passwordRetapVisible,
                      //                     decoration: InputDecoration(
                      //                       label: Text(
                      //                           "Retapez le nouveau mot de passe",
                      //                           style: TextStyle(
                      //                               fontSize: 20)),
                      //                       contentPadding:
                      //                           EdgeInsets.only(left: 30),
                      //                       enabledBorder:
                      //                           OutlineInputBorder(
                      //                         borderSide: BorderSide(
                      //                             color: Color.fromARGB(
                      //                                 255, 37, 50, 58)),
                      //                         borderRadius:
                      //                             BorderRadius.circular(
                      //                                 15),
                      //                       ),
                      //                       focusedBorder:
                      //                           OutlineInputBorder(
                      //                         borderSide: BorderSide(
                      //                             color: Color.fromARGB(
                      //                                 255, 99, 152, 187)),
                      //                         borderRadius:
                      //                             BorderRadius.circular(
                      //                                 15),
                      //                       ),
                      //                       suffixIcon: IconButton(
                      //                         icon: Icon(
                      //                             passwordRetapVisible
                      //                                 ? Icons.visibility
                      //                                 : Icons
                      //                                     .visibility_off),
                      //                         onPressed: () {
                      //                           setState(
                      //                             () {
                      //                               passwordRetapVisible =
                      //                                   !passwordRetapVisible;
                      //                             },
                      //                           );
                      //                         },
                      //                       ),
                      //                     ),
                      //                     keyboardType: TextInputType
                      //                         .visiblePassword,
                      //                     textInputAction:
                      //                         TextInputAction.done,
                      //                   ),
                      //                 ),
                      //               ],
                      //             ),
                      //             const SizedBox(height: 20),
                      //             Container(
                      //               decoration: BoxDecoration(
                      //                 color: Colors.white,
                      //                 borderRadius:
                      //                     BorderRadius.circular(30),
                      //               ),
                      //               child: ElevatedButton(
                      //                 child: Container(
                      //                     width: double.infinity,
                      //                     height: 50,
                      //                     child: Center(
                      //                         child: Text(
                      //                       "Enregistrer",
                      //                       style: TextStyle(
                      //                           color: Colors.black,
                      //                           fontWeight:
                      //                               FontWeight.w900),
                      //                     ))),
                      //                 onPressed: () {
                      //                   ModificationCompte();
                      //                 },
                      //                 style: ElevatedButton.styleFrom(
                      //                   foregroundColor: Color.fromARGB(
                      //                       255, 43, 0, 255),
                      //                   backgroundColor: kPrimaryColor,
                      //                   shape: RoundedRectangleBorder(
                      //                     borderRadius:
                      //                         BorderRadius.circular(15),
                      //                   ),
                      //                 ),
                      //               ),
                      //             ),
                      //             const SizedBox(height: 20),
                      //             Container(
                      //               decoration: BoxDecoration(
                      //                 color: Colors.white,
                      //                 borderRadius:
                      //                     BorderRadius.circular(30),
                      //               ),
                      //               child: ElevatedButton(
                      //                 child: SizedBox(
                      //                     width: double.infinity,
                      //                     height: 50,
                      //                     child: Center(
                      //                         child: Text(
                      //                       "Annuler",
                      //                       style: TextStyle(
                      //                           color: Color.fromARGB(
                      //                               255, 255, 255, 255),
                      //                           fontWeight:
                      //                               FontWeight.w900),
                      //                     ))),
                      //                 onPressed: () {
                      //                   setState(() {
                      //                     modification = false;
                      //                   });
                      //                 },
                      //                 style: ElevatedButton.styleFrom(
                      //                   foregroundColor: Color.fromARGB(
                      //                       255, 43, 0, 255),
                      //                   backgroundColor: Colors.red,
                      //                   shape: RoundedRectangleBorder(
                      //                     borderRadius:
                      //                         BorderRadius.circular(15),
                      //                   ),
                      //                 ),
                      //               ),
                      //             ),
                      //             SizedBox(
                      //               height: 20,
                      //             ),
                      //             Text(
                      //               MessageErrorController.text,
                      //               style: TextStyle(color: Colors.red),
                      //             ),
                      //           ],
                      //         ),
                      //       ),
                      //       const SizedBox(
                      //         width: 20,
                      //       ),
                      //     ],
                      //   ))
                      // :
                      Flexible(
                          child: Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 4,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 2,
                            child: Card(
                              elevation: 30,
                              child: Padding(
                                padding: EdgeInsets.all(40),
                                child: Column(
                                  children: [
                                    TextField(
                                      controller: nomController,
                                      decoration: InputDecoration(
                                        label: const Text(
                                          "Nom",
                                          style: TextStyle(fontSize: 20),
                                        ),
                                        contentPadding:
                                            const EdgeInsets.only(left: 30),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Color.fromARGB(
                                                  255, 37, 50, 58)),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Color.fromARGB(
                                                  255, 99, 152, 187)),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    TextField(
                                      controller: prenomController,
                                      decoration: InputDecoration(
                                        label: const Text("Prénom",
                                            style: TextStyle(fontSize: 20)),
                                        contentPadding:
                                            const EdgeInsets.only(left: 30),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Color.fromARGB(
                                                  255, 37, 50, 58)),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Color.fromARGB(
                                                  255, 99, 152, 187)),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    TextField(
                                      controller: contactController,
                                      decoration: InputDecoration(
                                        label: const Text("Contact",
                                            style: TextStyle(fontSize: 20)),
                                        contentPadding:
                                            const EdgeInsets.only(left: 30),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Color.fromARGB(
                                                  255, 37, 50, 58)),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Color.fromARGB(
                                                  255, 99, 152, 187)),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    TextField(
                                      controller: emailController,
                                      decoration: InputDecoration(
                                        label: const Text("Email",
                                            style: TextStyle(fontSize: 20)),
                                        contentPadding:
                                            const EdgeInsets.only(left: 30),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Color.fromARGB(
                                                  255, 37, 50, 58)),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Color.fromARGB(
                                                  255, 99, 152, 187)),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    const SizedBox(height: 20),
                                    DropdownSearch<String>(
                                      mode: Mode.MENU,
                                      showSelectedItems: true,
                                      items: ListeToutPays,
                                      selectedItem: PaysController.text,
                                      onChanged: (value) {
                                        if (value != null) {
                                          setState(() {
                                            PaysController.text = value;
                                          });
                                        }
                                      },
                                      showSearchBox: true,
                                      searchFieldProps: TextFieldProps(
                                        cursorColor: Colors.blue,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    TextField(
                                      controller: ProvinceController,
                                      decoration: InputDecoration(
                                        label: Text("Province",
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Color.fromARGB(
                                                    255, 0, 0, 0))),
                                        contentPadding:
                                            EdgeInsets.only(left: 30),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0)),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color.fromARGB(
                                                  255, 99, 152, 187)),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    TextField(
                                      controller: VilleController,
                                      decoration: InputDecoration(
                                        label: Text("Ville",
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Color.fromARGB(
                                                    255, 0, 0, 0))),
                                        contentPadding:
                                            EdgeInsets.only(left: 30),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0)),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color.fromARGB(
                                                  255, 99, 152, 187)),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    TextField(
                                      controller: CodePostalController,
                                      decoration: InputDecoration(
                                        label: Text("Code postal",
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Color.fromARGB(
                                                    255, 0, 0, 0))),
                                        contentPadding:
                                            EdgeInsets.only(left: 30),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0)),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color.fromARGB(
                                                  255, 99, 152, 187)),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    TextField(
                                      controller: AdresseController,
                                      decoration: InputDecoration(
                                        label: Text("Adresse",
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Color.fromARGB(
                                                    255, 0, 0, 0))),
                                        contentPadding:
                                            EdgeInsets.only(left: 30),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0)),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color.fromARGB(
                                                  255, 99, 152, 187)),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    TextField(
                                      controller: VoieController,
                                      decoration: InputDecoration(
                                        label: Text("Voie",
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Color.fromARGB(
                                                    255, 0, 0, 0))),
                                        contentPadding:
                                            EdgeInsets.only(left: 30),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0)),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color.fromARGB(
                                                  255, 99, 152, 187)),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    TextField(
                                      controller: ComplementController,
                                      decoration: InputDecoration(
                                        label: Text("Complement",
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Color.fromARGB(
                                                    255, 0, 0, 0))),
                                        contentPadding:
                                            EdgeInsets.only(left: 30),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0)),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color.fromARGB(
                                                  255, 99, 152, 187)),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    TextField(
                                      controller: passwordActuelController,
                                      onChanged: (value) {
                                        if (value.trim() != "") {
                                          setState(() {
                                            enabledNewPass = true;
                                          });
                                        } else {
                                          enabledNewPass = false;
                                          passwordNouveauController.text = "";
                                          passwordNouveauController.text = "";
                                        }
                                      },
                                      obscureText: passwordActuelVisible,
                                      decoration: InputDecoration(
                                        label: const Text("Mot de passe actuel",
                                            style: TextStyle(fontSize: 20)),
                                        contentPadding:
                                            const EdgeInsets.only(left: 30),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Color.fromARGB(
                                                  255, 37, 50, 58)),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Color.fromARGB(
                                                  255, 99, 152, 187)),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        suffixIcon: IconButton(
                                          icon: Icon(passwordActuelVisible
                                              ? Icons.visibility
                                              : Icons.visibility_off),
                                          onPressed: () {
                                            setState(
                                              () {
                                                passwordActuelVisible =
                                                    !passwordActuelVisible;
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                      keyboardType:
                                          TextInputType.visiblePassword,
                                      textInputAction: TextInputAction.done,
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    TextField(
                                      enabled: enabledNewPass,
                                      controller: passwordNouveauController,
                                      obscureText: passwordNouveauVisible,
                                      decoration: InputDecoration(
                                        label: const Text(
                                            "Nouveau mot de passe",
                                            style: TextStyle(fontSize: 20)),
                                        contentPadding:
                                            const EdgeInsets.only(left: 30),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Color.fromARGB(
                                                  255, 37, 50, 58)),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Color.fromARGB(
                                                  255, 99, 152, 187)),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        suffixIcon: IconButton(
                                          icon: Icon(passwordNouveauVisible
                                              ? Icons.visibility
                                              : Icons.visibility_off),
                                          onPressed: () {
                                            setState(
                                              () {
                                                passwordNouveauVisible =
                                                    !passwordNouveauVisible;
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                      keyboardType:
                                          TextInputType.visiblePassword,
                                      textInputAction: TextInputAction.done,
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    TextField(
                                      enabled: enabledNewPass,
                                      controller: passwordRetapController,
                                      obscureText: passwordRetapVisible,
                                      decoration: InputDecoration(
                                        label: const Text(
                                            "Retapez le nouveau mot de passe",
                                            style: TextStyle(fontSize: 20)),
                                        contentPadding:
                                            const EdgeInsets.only(left: 30),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Color.fromARGB(
                                                  255, 37, 50, 58)),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Color.fromARGB(
                                                  255, 99, 152, 187)),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        suffixIcon: IconButton(
                                          icon: Icon(passwordRetapVisible
                                              ? Icons.visibility
                                              : Icons.visibility_off),
                                          onPressed: () {
                                            setState(
                                              () {
                                                passwordRetapVisible =
                                                    !passwordRetapVisible;
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                      keyboardType:
                                          TextInputType.visiblePassword,
                                      textInputAction: TextInputAction.done,
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    ElevatedButton(
                                      child: const SizedBox(
                                          width: double.infinity,
                                          height: 50,
                                          child: Center(
                                              child: Text(
                                            "Enregistrer",
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 255, 255, 255),
                                                fontWeight: FontWeight.w900),
                                          ))),
                                      onPressed: () {
                                        ModificationCompte();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        elevation: 10,
                                        backgroundColor: const Color.fromARGB(
                                            255, 43, 0, 255),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    ElevatedButton(
                                      child: const SizedBox(
                                          width: double.infinity,
                                          height: 50,
                                          child: Center(
                                              child: Text(
                                            "Annuler",
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 255, 255, 255),
                                                fontWeight: FontWeight.w900),
                                          ))),
                                      onPressed: () {
                                        setState(() {
                                          modification = false;
                                        });
                                      },
                                      style: ElevatedButton.styleFrom(
                                        elevation: 10,
                                        backgroundColor: ColorBtnAnnule,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      MessageErrorController.text,
                                      style: const TextStyle(color: Colors.red),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                        ],
                      )),
                    ],
                  ),
                ),

              if (modification == false)
                Row(
                  children: [
                    Center(
                      child: Row(
                        children: <Widget>[
                          Row(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 4,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 2,
                                // width: MediaQuery.of(context).size.width / 3,
                                child: Card(
                                  elevation: 20,
                                  child: Padding(
                                    padding: EdgeInsets.all(40),
                                    child: Column(
                                      children: [
                                        Text(
                                          "Mon Profil",
                                          style: TextStyle(
                                              fontSize: fontResponsive(
                                                  MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  24),
                                              fontWeight: FontWeight.w700),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Row(
                                          children: [
                                            const Flexible(
                                              child: Text("Nom complet : "),
                                            ),
                                            Flexible(
                                              child: Text(
                                                Connection[0]["nom"] +
                                                    " " +
                                                    Connection[0]["prenom"],
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 20),
                                        Row(
                                          children: [
                                            const Flexible(
                                              child: Text("Email : "),
                                            ),
                                            Flexible(
                                              child: Text(
                                                Connection[0]["email"],
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.w700),
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
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.w700),
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
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 20),
                                        Row(
                                          children: [
                                            const Flexible(
                                              child:
                                                  Text("Province / Ville : "),
                                            ),
                                            Flexible(
                                              child: Text(
                                                Connection[0]["province"] +
                                                    " / " +
                                                    Connection[0]["ville"],
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.w700),
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
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 20),
                                        Row(
                                          children: [
                                            const Flexible(
                                              child:
                                                  Text("Voie / Complement : "),
                                            ),
                                            Flexible(
                                              child: Text(
                                                Connection[0]["voie"] +
                                                    " / " +
                                                    Connection[0]["complement"],
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 20),
                                        ElevatedButton(
                                          child: const SizedBox(
                                              width: double.infinity,
                                              height: 50,
                                              child: Center(
                                                  child: Text(
                                                "Modifier",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.w900),
                                              ))),
                                          onPressed: () {
                                            // getInscription();
                                            setState(() {
                                              modification = true;
                                              MessageApresModification.text =
                                                  "";
                                              passwordActuelController.text =
                                                  "";
                                              passwordNouveauController.text =
                                                  "";
                                              passwordRetapController.text = "";
                                            });
                                          },
                                          style: ElevatedButton.styleFrom(
                                            elevation: 10,
                                            backgroundColor: kPrimaryColor,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // ),
                  ],
                ),

              const SizedBox(
                height: 30,
              ),
              if (modification == false)
                Padding(
                  padding: EdgeInsets.all(40),
                  child: Text(
                    "Mes Achats",
                    style: TextStyle(
                      fontSize:
                          fontResponsive(MediaQuery.of(context).size.width, 24),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              if (modification == false)
                Row(
                  children: <Widget>[
                    if (MediaQuery.of(context).size.width < 500)
                      Flexible(
                          child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            horizontalMargin: 0,
                            columnSpacing:
                                (MediaQuery.of(context).size.width / 10) * 0.5,
                            dataRowHeight: 80,
                            columns: const [
                              DataColumn(
                                label: Text("Date"),
                              ),
                              DataColumn(
                                label: Text("Montant"),
                              ),
                              // DataColumn(
                              //   label: Text("Date de livraison"),
                              // ),
                              DataColumn(
                                label: Text("Etat"),
                              ),
                              DataColumn(
                                label: Text(""),
                              ),
                            ],
                            rows: List.generate(
                              ListeCommandesClient.length,
                              (index) => recentCommandeDataRow(
                                  ListeCommandesClient[index]),
                            ),
                          ),
                        ),
                      )),
                    if (MediaQuery.of(context).size.width >= 500)
                      Flexible(
                        child: Center(
                          child: Card(
                            elevation: 20,
                            child: Padding(
                              padding: EdgeInsets.all(40),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width / 1.5,
                                child: DataTable(
                                  horizontalMargin: 0,
                                  columnSpacing: kPadding,
                                  columns: const [
                                    DataColumn(
                                      label: Text("Date"),
                                    ),
                                    DataColumn(
                                      label: Text("Montant"),
                                    ),
                                    // DataColumn(
                                    //   label: Text("Date de livraison"),
                                    // ),
                                    DataColumn(
                                      label: Text("Etat"),
                                    ),
                                    DataColumn(
                                      label: Text(""),
                                    ),
                                  ],
                                  rows: List.generate(
                                    ListeCommandesClient.length,
                                    (index) => recentCommandeDataRow(
                                        ListeCommandesClient[index]),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              const SizedBox(
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

 // if (Connection[0]["statut"] == false)
                    //   SizedBox(
                    //     height:
                    //         MediaQuery.of(context).size.width > 300 ? 40 : 50,
                    //     width: MediaQuery.of(context).size.width > 300
                    //         ? btnResponsive(MediaQuery.of(context).size.width)
                    //         : 50,
                    //     child: ElevatedButton(
                    //       style: ElevatedButton.styleFrom(
                    //           backgroundColor:
                    //               const Color.fromARGB(255, 255, 255, 255),
                    //           shape: (MediaQuery.of(context).size.width <= 300)
                    //               ? CircleBorder()
                    //               : RoundedRectangleBorder(
                    //                   borderRadius: BorderRadius.circular(30.0),
                    //                 ),
                    //           // padding: EdgeInsets.all(20),

                    //           elevation: 10),
                    //       onPressed: () {
                    //         redirection = "1";
                    //         myNavigator(context, "0");
                    //       },
                    //       child: Row(
                    //         mainAxisSize: MainAxisSize.min,
                    //         children: [
                    //           // if (MediaQuery.of(context).size.width > 300)
                    //           //   Text(
                    //           //     "Se connecter",
                    //           //     style: TextStyle(
                    //           //         fontSize: fontResponsive(
                    //           //             MediaQuery.of(context).size.width,
                    //           //             14),
                    //           //         color: Colors.black,
                    //           //         fontWeight: FontWeight.w700),
                    //           //   ),
                    //           // if (MediaQuery.of(context).size.width <= 300)
                    //             const Icon(
                    //               Icons.person,
                    //               color: Color.fromARGB(255, 64, 0, 255),
                    //               size: 18,
                    //             ),
                    //         ],
                    //       ),
                    //     ),
                    //   ),