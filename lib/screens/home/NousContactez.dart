// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:online_food_ordering_web/constants.dart';
import 'components/footer.dart';
import 'components/header_container.dart';
import 'components/menu.dart';
import 'package:http/http.dart' as http;

class NousContactez extends StatefulWidget {
  const NousContactez({Key? key}) : super(key: key);

  @override
  _NousContactezState createState() => _NousContactezState();
}

class _NousContactezState extends State<NousContactez> {
  final nomController = TextEditingController();
  final emailController = TextEditingController();
  final objetController = TextEditingController();
  final messageController = TextEditingController();

  final MessageErrorController = TextEditingController();

  Future<void> getContact() async {
    try {
      List detailContact = [];
      var responseContact = await http.post(Uri.parse(url_contact),
          headers: {"content-type": "application/json"},
          body: jsonEncode({
            "nom": nomController.text,
            "email": emailController.text,
            "objet": objetController.text,
            "message": messageController.text
          }));

      if (responseContact.statusCode == 200) {
        detailContact = json.decode(responseContact.body);
        bool boolean = detailContact[0]["statut"] == "0" ? false : true;

        setState(() {
          MessageErrorController.text = detailContact[0]["msg"];
        });
        if (boolean) {
          setState(() {
            nomController.text = "";
            emailController.text = "";
            objetController.text = "";
            messageController.text = "";
          });
        }
      } else {
        MessageErrorController.text =
            "Une erreur est survenu , veuillez ressayer s'il vous plait!";
      }
    } catch (e) {
      print(e);
    }
  }

  whereProduit(String input) {}

  @override
  void initState() {
    super.initState();
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
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(imageContact),
                    fit: BoxFit.cover,
                  ),
                ),
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
                                  ? MediaQuery.of(context).size.width * 0.15
                                  : MediaQuery.of(context).size.width * 0.1),
                          Container(
                            width: MediaQuery.of(context).size.width > 700
                                ? MediaQuery.of(context).size.width * 0.65
                                : MediaQuery.of(context).size.width * 0.80,
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: Color.fromARGB(223, 255, 255, 255),
                            ),
                            child: MediaQuery.of(context).size.width > 700
                                ? Column(
                                    children: [
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "Laissez nous un message",
                                        style: TextStyle(
                                            fontSize: fontResponsive(
                                                MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                20),
                                            fontWeight: FontWeight.w700),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        children: [
                                          Flexible(
                                            child: TextField(
                                              controller: nomController,
                                              decoration: InputDecoration(
                                                label: Text(
                                                  "Nom",
                                                  style:
                                                      TextStyle(fontSize: 20),
                                                ),
                                                contentPadding:
                                                    EdgeInsets.only(left: 30),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Color.fromARGB(
                                                          255, 37, 50, 58)),
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Color.fromARGB(
                                                          255, 99, 152, 187)),
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Flexible(
                                            child: TextField(
                                              controller: emailController,
                                              decoration: InputDecoration(
                                                label: Text("Email",
                                                    style: TextStyle(
                                                        fontSize: 20)),
                                                contentPadding:
                                                    EdgeInsets.only(left: 30),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Color.fromARGB(
                                                          255, 37, 50, 58)),
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
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
                                      Row(
                                        children: [
                                          Flexible(
                                            child: TextField(
                                              controller: objetController,
                                              decoration: InputDecoration(
                                                label: Text("Objet",
                                                    style: TextStyle(
                                                        fontSize: 20)),
                                                contentPadding:
                                                    EdgeInsets.only(left: 30),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Color.fromARGB(
                                                          255, 37, 50, 58)),
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
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
                                      Row(
                                        children: [
                                          Flexible(
                                            child: TextField(
                                              controller: messageController,
                                              decoration: InputDecoration(
                                                // contentPadding: EdgeInsets.symmetric(vertical: 40),
                                                label: Text("Message",
                                                    style: TextStyle(
                                                        fontSize: 20)),
                                                contentPadding: EdgeInsets.only(
                                                    left: 30,
                                                    top: 50,
                                                    bottom: 50),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Color.fromARGB(
                                                          255, 37, 50, 58)),
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Color.fromARGB(
                                                          255, 99, 152, 187)),
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                              ),
                                              maxLines: 5,
                                              minLines: 1,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 20),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        child: ElevatedButton(
                                          child: SizedBox(
                                              width: double.infinity,
                                              height: 50,
                                              child: Center(
                                                  child: Text(
                                                "Envoyer",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.w900),
                                              ))),
                                          onPressed: () {
                                            getContact();
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
                                        height: 10,
                                      ),
                                      Text(
                                        MessageErrorController.text,
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ],
                                  )
                                : Column(
                                    children: [
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "Laissez nous un message",
                                        style: TextStyle(
                                            fontSize: fontResponsive(
                                                MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                20),
                                            fontWeight: FontWeight.w700),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      TextField(
                                        controller: nomController,
                                        decoration: InputDecoration(
                                          label: Text(
                                            "Nom",
                                            style: TextStyle(fontSize: 20),
                                          ),
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
                                      const SizedBox(height: 20),
                                      TextField(
                                        controller: emailController,
                                        decoration: InputDecoration(
                                          label: Text("Email",
                                              style: TextStyle(fontSize: 20)),
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
                                      const SizedBox(height: 20),
                                      TextField(
                                        controller: objetController,
                                        decoration: InputDecoration(
                                          label: Text("Objet",
                                              style: TextStyle(fontSize: 20)),
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
                                      const SizedBox(height: 20),
                                      TextField(
                                        controller: messageController,
                                        decoration: InputDecoration(
                                          label: Text("Message",
                                              style: TextStyle(fontSize: 20)),
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
                                        maxLines: 5, // <-- SEE HERE
                                        minLines: 1,
                                      ),
                                      const SizedBox(height: 20),
                                      ElevatedButton(
                                        child: SizedBox(
                                            width: double.infinity,
                                            height: 50,
                                            child: Center(
                                                child: Text(
                                              "Envoyer",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w900),
                                            ))),
                                        onPressed: () {
                                          getContact();
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
                        ],
                      )),
                    ],
                  ),
                ),
              ),
              Footer(),
            ],
          ),
        ),
      ),

      // persistentFooterButtons: const [
      //   Icon(Icons.settings),
      //   SizedBox(width: 5),
      //   Icon(Icons.exit_to_app),
      //   SizedBox(
      //     width: 10,
      //   ),
      // ],
    );
  }
}
