// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:online_food_ordering_web/model.dart/responsive.dart';
import '../../../constants.dart';
// import 'header.dart';
import 'menu.dart';

class HeaderContainer extends StatelessWidget {
  HeaderContainer({Key? key, this.isIndex = true, required this.onChange})
      : super(key: key);
  final Function onChange;

  bool isIndex;
  @override
  Widget build(BuildContext context) {
    LogOut() {
      try {
        Connection[0]["statut"] = false;
        Connection[0]["nom"] = "";
        Connection[0]["prenom"] = "";
        Connection[0]["nom_complet"] = "";
        Connection[0]["contact"] = "";
        Connection[0]["image"] = "";
        Connection[0]["id"] = "";

        myNavigator(context, 1);
      } catch (e) {
        print(e);
      }
    }

    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imageHeader),
          fit: BoxFit.cover,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(70, 0, 0, 0),
            blurRadius: 4,
            offset: Offset(4, 8), // Shadow position
          ),
        ],
      ),
      padding: EdgeInsets.all(8.0),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(0.5),
            constraints: BoxConstraints(maxWidth: kMaxWidth),
            child: Column(
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                Row(
                  children: [
                    if (!Responsive.isDesktop(context))
                      Builder(
                          builder: (context) => IconButton(
                              onPressed: () {
                                Scaffold.of(context).openDrawer();
                              },
                              icon: const Icon(Icons.menu))),
                    if (MediaQuery.of(context).size.width >= 900)
                      Image.asset(
                        logoSite,
                        height: 90,
                        width: 90,
                      ),
                    const Spacer(),
                    if (MediaQuery.of(context).size.width >= 400)
                      SizedBox(
                        width: MediaQuery.of(context).size.width >= 460
                            ? 205
                            : 150,
                        // height: 40,
                        child: TextField(
                          onChanged: (value) {
                            if (value != "") {
                              onChange(value);
                            } else {
                              onChange("tout");
                            }
                          },
                          decoration: const InputDecoration(
                              filled: true, //<-- SEE HERE
                              fillColor:
                                  Color.fromARGB(255, 255, 255, 255), //<-- SEE
                              prefixIcon: Icon(Icons.search),
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)))),
                        ),
                      ),
                    if (MediaQuery.of(context).size.width < 900)
                      const SizedBox(
                        width: 20,
                      ),
                    //menu

                    if (Responsive.isDesktop(context)) HeaderWebMenu(),

                    const SizedBox(
                      width: 5,
                    ),
                    SizedBox(
                      height: 50,
                      width: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: ShoppingButtonColor,
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(5),
                            elevation: 10),
                        onPressed: () {
                          myNavigator(context, "5");
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(
                              Icons.shopping_cart,
                              color: Color.fromARGB(255, 0, 0, 0),
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),

                    if (Connection[0]["statut"] == true)
                      SizedBox(
                        height: 50,
                        width: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 255, 255, 255),
                              shape: const CircleBorder(),
                              // padding: EdgeInsets.all(20),
                              elevation: 10),
                          onPressed: () {
                            LogOut();
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(
                                Icons.logout,
                                color: Color.fromARGB(255, 255, 0, 0),
                                size: 18,
                              ),
                            ],
                          ),
                        ),
                      ),

                    const SizedBox(
                      height: 100,
                    )
                  ],
                ),
                SizedBox(
                  height: Responsive.isDesktop(context) ? 5 : 0,
                ),
                // if (isIndex)
                //   Responsive.isDesktop(context) ? BannerSection() : MobBanner(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
