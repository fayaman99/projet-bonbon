// ignore_for_file: prefer_const_constructors
import 'package:dropdown_search/dropdown_search.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:online_food_ordering_web/constants.dart';
import '../../model.dart/ListePays.dart';
import '../../popup.dart';
import 'components/footer.dart';
import 'components/header_container.dart';
import 'components/menu.dart';
import 'package:http/http.dart' as http;

class InscriptionScreen extends StatefulWidget {
  const InscriptionScreen({Key? key}) : super(key: key);

  @override
  _InscriptionScreenState createState() => _InscriptionScreenState();
}

class _InscriptionScreenState extends State<InscriptionScreen> {
  final nomController = TextEditingController();
  final prenomController = TextEditingController();
  final contactController = TextEditingController();
  final emailController = TextEditingController();
  final loginController = TextEditingController();
  final passwordController = TextEditingController();
  final codeValidationController = TextEditingController();
  final PaysController = TextEditingController();
  final ProvinceController = TextEditingController();
  final CodePostalController = TextEditingController();
  final VilleController = TextEditingController();
  final VoieController = TextEditingController();
  final ComplementController = TextEditingController();
  final MessageErrorController = TextEditingController();
  final AdresseController = TextEditingController();

  bool passwordVisible = false;
  bool codeConfirmation = false;

  @override
  Future<void> getInscription() async {
    try {
      List detailInscription = [];
      var responseLogin = await http.post(Uri.parse(url_inscription),
          headers: {"content-type": "application/json"},
          body: jsonEncode({
            "nom": nomController.text,
            "prenom": prenomController.text,
            "contact": contactController.text,
            "email": emailController.text,
            "login": loginController.text,
            "pays": PaysController.text,
            "province": ProvinceController.text,
            "code_postal": CodePostalController.text,
            "ville": VilleController.text,
            "voie": VoieController.text,
            "complement": ComplementController.text,
            "adresse": AdresseController.text,
            "password": passwordController.text,
          }));
      print(jsonEncode({
        "nom": nomController.text,
        "prenom": prenomController.text,
        "contact": contactController.text,
        "email": emailController.text,
        "login": loginController.text,
        "pays": PaysController.text,
        "province": ProvinceController.text,
        "code_postal": CodePostalController.text,
        "ville": VilleController.text,
        "voie": VoieController.text,
        "complement": ComplementController.text,
        "adresse": AdresseController.text,
        "password": passwordController.text,
      }));
      print(responseLogin.body);
      if (responseLogin.statusCode == 200) {
        detailInscription = json.decode(responseLogin.body);
        if (detailInscription[0]["statut"] == "0") {
          reponseCommande(context, detailInscription[0]["msg"], false);
        } else {
          setState(() {
            // codeConfirmation = true;
            myNavigator(context, "0");
          });
        }
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> verifCodeValidation() async {
    try {
      List repValidation = [];
      var responseLogin = await http.post(Uri.parse(url_inscription),
          headers: {"content-type": "application/json"},
          body: jsonEncode({
            "code": codeValidationController.text,
            "email": emailController.text
          }));

      if (responseLogin.statusCode == 200) {
        repValidation = json.decode(responseLogin.body);
        if (repValidation[0]["statut"] == "0") {
          reponseCommande(context, repValidation[0]["msg"], "0");
        } else {
          codeConfirmation = false;
          myNavigator(context, "0");
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
    passwordVisible = true;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawerMenu(),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              //header
              HeaderContainer(
                isIndex: false,
                onChange: whereProduit,
              ),

              if (codeConfirmation == false)
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(imageLogin),
                      fit: BoxFit.cover,
                    ),
                  ),
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Center(
                    child: Row(
                      children: <Widget>[
                        Flexible(
                            child: Row(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height > 900
                                  ? (MediaQuery.of(context).size.height * 0.9 +
                                      20)
                                  : (MediaQuery.of(context).size.height * 0.75 +
                                      20),
                            ),
                            SizedBox(
                                width: MediaQuery.of(context).size.width > 700
                                    ? MediaQuery.of(context).size.width / 4
                                    : MediaQuery.of(context).size.width * 0.1),
                            Container(
                              width: MediaQuery.of(context).size.width > 700
                                  ? MediaQuery.of(context).size.width / 2
                                  : MediaQuery.of(context).size.width * 0.80,
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: Color.fromARGB(223, 255, 255, 255),
                              ),
                              child: Column(
                                children: [
                                  SizedBox(height: 5),
                                  Text(
                                    "Inscription",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  TextField(
                                    controller: nomController,
                                    decoration: InputDecoration(
                                      label: Text("Nom",
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Color.fromARGB(
                                                  255, 0, 0, 0))),
                                      contentPadding: EdgeInsets.only(left: 30),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                Color.fromARGB(255, 0, 0, 0)),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color.fromARGB(
                                                255, 0, 153, 255)),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  TextField(
                                    controller: prenomController,
                                    decoration: InputDecoration(
                                      label: Text("Prénom",
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Color.fromARGB(
                                                  255, 0, 0, 0))),
                                      contentPadding: EdgeInsets.only(left: 30),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                Color.fromARGB(255, 0, 0, 0)),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color.fromARGB(
                                                255, 99, 152, 187)),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  TextField(
                                    controller: contactController,
                                    decoration: InputDecoration(
                                      label: Text("Contact",
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Color.fromARGB(
                                                  255, 0, 0, 0))),
                                      contentPadding: EdgeInsets.only(left: 30),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                Color.fromARGB(255, 0, 0, 0)),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color.fromARGB(
                                                255, 99, 152, 187)),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  TextField(
                                    controller: emailController,
                                    decoration: InputDecoration(
                                      label: Text("Email",
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Color.fromARGB(
                                                  255, 0, 0, 0))),
                                      contentPadding: EdgeInsets.only(left: 30),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                Color.fromARGB(255, 0, 0, 0)),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color.fromARGB(
                                                255, 99, 152, 187)),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  DropdownSearch<String>(
                                    mode: Mode.MENU,
                                    showSelectedItems: true,
                                    items: ListeToutPays,
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
                                      contentPadding: EdgeInsets.only(left: 30),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                Color.fromARGB(255, 0, 0, 0)),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color.fromARGB(
                                                255, 99, 152, 187)),
                                        borderRadius: BorderRadius.circular(15),
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
                                      contentPadding: EdgeInsets.only(left: 30),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                Color.fromARGB(255, 0, 0, 0)),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color.fromARGB(
                                                255, 99, 152, 187)),
                                        borderRadius: BorderRadius.circular(15),
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
                                      contentPadding: EdgeInsets.only(left: 30),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                Color.fromARGB(255, 0, 0, 0)),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color.fromARGB(
                                                255, 99, 152, 187)),
                                        borderRadius: BorderRadius.circular(15),
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
                                      contentPadding: EdgeInsets.only(left: 30),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                Color.fromARGB(255, 0, 0, 0)),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color.fromARGB(
                                                255, 99, 152, 187)),
                                        borderRadius: BorderRadius.circular(15),
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
                                      contentPadding: EdgeInsets.only(left: 30),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                Color.fromARGB(255, 0, 0, 0)),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color.fromARGB(
                                                255, 99, 152, 187)),
                                        borderRadius: BorderRadius.circular(15),
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
                                      contentPadding: EdgeInsets.only(left: 30),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                Color.fromARGB(255, 0, 0, 0)),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color.fromARGB(
                                                255, 99, 152, 187)),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  TextField(
                                    controller: loginController,
                                    decoration: InputDecoration(
                                      label: Text("Nom d'utilisateur",
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Color.fromARGB(
                                                  255, 0, 0, 0))),
                                      contentPadding: EdgeInsets.only(left: 30),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                Color.fromARGB(255, 0, 0, 0)),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color.fromARGB(
                                                255, 99, 152, 187)),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  TextField(
                                    controller: passwordController,
                                    obscureText: passwordVisible,
                                    decoration: InputDecoration(
                                      label: Text("Mot de passe",
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Color.fromARGB(
                                                  255, 0, 0, 0))),
                                      contentPadding: EdgeInsets.only(left: 30),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                Color.fromARGB(255, 0, 0, 0)),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color.fromARGB(
                                                255, 99, 152, 187)),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      suffixIcon: IconButton(
                                        icon: Icon(passwordVisible
                                            ? Icons.visibility
                                            : Icons.visibility_off),
                                        onPressed: () {
                                          setState(
                                            () {
                                              passwordVisible =
                                                  !passwordVisible;
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                    keyboardType: TextInputType.visiblePassword,
                                    textInputAction: TextInputAction.done,
                                  ),
                                  const SizedBox(height: 20),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 0, 123, 255),
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: ElevatedButton(
                                      child: SizedBox(
                                          width: double.infinity,
                                          height: 50,
                                          child: Center(
                                              child: Text(
                                            "S'inscrire",
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 255, 255, 255),
                                                fontWeight: FontWeight.w900),
                                          ))),
                                      onPressed: () {
                                        getInscription();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor:
                                            Color.fromARGB(255, 0, 0, 0),
                                        backgroundColor:
                                            Color.fromARGB(255, 34, 156, 196),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    MessageErrorController.text,
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )),
                      ],
                    ),
                  ),
                ),
              if (codeConfirmation == true)
                Container(
                  width: double.infinity,
                  // color: Colors.amber,
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Center(
                    child: Row(
                      children: <Widget>[
                        Flexible(
                            child: Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 4,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 2,
                              // width: MediaQuery.of(context).size.width / 3,
                              child: Column(
                                children: [
                                  Center(
                                    child: Text("Code de confirmation"),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    children: [
                                      Flexible(
                                        child: TextField(
                                          controller: codeValidationController,
                                          decoration: InputDecoration(
                                            contentPadding:
                                                EdgeInsets.only(left: 30),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color.fromARGB(
                                                      255, 37, 50, 58)),
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
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: ElevatedButton(
                                      child: SizedBox(
                                          width: double.infinity,
                                          height: 50,
                                          child: Center(
                                              child: Text(
                                            "Valider",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w900),
                                          ))),
                                      onPressed: () {
                                        verifCodeValidation();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor:
                                            Color.fromARGB(255, 43, 0, 255),
                                        backgroundColor: kPrimaryColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    MessageErrorController.text,
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Text(" ")
                          ],
                        )),
                      ],
                    ),
                  ),
                ),
              //footer

              Footer(),
              //now we make our website responsive
            ],
          ),
        ),
      ),
    );
  }
}
