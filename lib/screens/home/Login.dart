// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:online_food_ordering_web/constants.dart';
import 'components/footer.dart';
import 'components/header_container.dart';
import 'components/menu.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Future<void> getConnection(login, password) async {
    try {
      List detailLogin = [];
      var responseLogin = await http.post(Uri.parse(url_login),
          headers: {"content-type": "application/json"},
          body: jsonEncode({"login": login, "password": password}));

      if (responseLogin.statusCode == 200) {
        detailLogin = json.decode(responseLogin.body);

        if (detailLogin[0]["statut"] == "1") {
          Connection[0]["statut"] = true;
          Connection[0]["nom"] = detailLogin[0]["nom"];
          Connection[0]["prenom"] = detailLogin[0]["prenom"];
          Connection[0]["nom_complet"] = detailLogin[0]["nom_complet"];
          Connection[0]["contact"] = detailLogin[0]["contact"];
          Connection[0]["id"] = detailLogin[0]["id"];
          Connection[0]["email"] = detailLogin[0]["email"];
          Connection[0]["voie"] = detailLogin[0]["voie"];
          Connection[0]["code_postal"] = detailLogin[0]["code_postal"];
          Connection[0]["province"] = detailLogin[0]["province"];
          Connection[0]["ville"] = detailLogin[0]["ville"];
          Connection[0]["pays"] = detailLogin[0]["pays"];
          Connection[0]["adresse"] = detailLogin[0]["adresse"];
          Connection[0]["complement"] = detailLogin[0]["complement"];
          myNavigator(context, redirection);
        } else {
          setState(() {
            MessageErrorController.text = detailLogin[0]["msg"];
          });
        }
      }
    } catch (e) {
      print(e);
    }
  }

  final loginController = TextEditingController();
  final passwordController = TextEditingController();
  final MessageErrorController = TextEditingController();
  bool passwordVisible = false;
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

              Container(
                padding: EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(imageLogin),
                    fit: BoxFit.cover,
                  ),
                ),
                width: double.infinity,
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
                                  ? MediaQuery.of(context).size.width / 3
                                  : MediaQuery.of(context).size.width * 0.1),
                          Container(
                            width: MediaQuery.of(context).size.width > 700
                                ? MediaQuery.of(context).size.width / 3
                                : MediaQuery.of(context).size.width * 0.80,
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: Color.fromARGB(223, 255, 255, 255),
                            ),
                            // width: MediaQuery.of(context).size.width / 3,
                            child: Column(
                              children: [
                                SizedBox(height: 10),
                                Text(
                                  "Connexion",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                TextField(
                                  controller: loginController,
                                  decoration: InputDecoration(
                                    hintText: 'Email ou contact',
                                    filled: true,
                                    fillColor: Colors.blueGrey[50],
                                    labelStyle: TextStyle(fontSize: 12),
                                    contentPadding: EdgeInsets.only(left: 30),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color.fromARGB(255, 0, 0, 0)),
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
                                const SizedBox(height: 30),
                                TextField(
                                  obscureText: passwordVisible,
                                  controller: passwordController,
                                  decoration: InputDecoration(
                                    hintText: 'Mot de passe',
                                    // counterText: 'Mot de passe oubliée?',
                                    suffixIcon: IconButton(
                                      icon: Icon(passwordVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off),
                                      onPressed: () {
                                        setState(
                                          () {
                                            passwordVisible = !passwordVisible;
                                          },
                                        );
                                      },
                                    ),
                                    filled: true,
                                    fillColor: Colors.blueGrey[50],
                                    labelStyle: TextStyle(fontSize: 12),
                                    contentPadding: EdgeInsets.only(left: 30),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color.fromARGB(255, 0, 0, 0)),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color.fromARGB(
                                              255, 78, 137, 175)),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                if (MediaQuery.of(context).size.width >= 1000)
                                  Row(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          // myNavigator(context, "2");
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20),
                                          child: Text(
                                            "Mot de passe oublié ?",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 12,
                                                color: Colors.blue),
                                          ),
                                        ),
                                      ),
                                      Text(" ou "),
                                      InkWell(
                                        onTap: () {
                                          myNavigator(context, "6");
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20),
                                          child: Text(
                                            "S'inscrire",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 12,
                                                color: Colors.blue),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                if (MediaQuery.of(context).size.width < 1000)
                                  Column(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          // myNavigator(context, "2");
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20),
                                          child: Text(
                                            "Mot de passe oublié ?",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: fontResponsive(
                                                    MediaQuery.of(context)
                                                        .size
                                                        .width,
                                                    12),
                                                color: Colors.blue),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        " ou ",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: fontResponsive(
                                              MediaQuery.of(context).size.width,
                                              12),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          myNavigator(context, "6");
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20),
                                          child: Text(
                                            "S'inscrire",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: fontResponsive(
                                                    MediaQuery.of(context)
                                                        .size
                                                        .width,
                                                    12),
                                                color: Colors.blue),
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
                                          "Se connecter",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w900),
                                        ))),
                                    onPressed: () {
                                      getConnection(loginController.text,
                                          passwordController.text);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor:
                                          Color.fromARGB(255, 43, 0, 255),
                                      backgroundColor: kPrimaryColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  MessageErrorController.text,
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.w700),
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
