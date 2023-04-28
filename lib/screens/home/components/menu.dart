import 'package:flutter/material.dart';
import '../../../constants.dart';

class HeaderWebMenu extends StatelessWidget {
  const HeaderWebMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (int i = 0; ListeHeaderPage.length > i; i++)
          HeaderMenu(
            press: () {
              myNavigator(context, ListeHeaderPage[i]["code"]);
            },
            title: ListeHeaderPage[i]["title"],
          ),
        const SizedBox(
          width: 10,
        ),
      ],
    );
  }
}

class MobFooterMenu extends StatelessWidget {
  const MobFooterMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        for (int i = 0; ListeHeaderPage.length > i; i++)
          HeaderMenu(
            press: () {
              myNavigator(context, ListeHeaderPage[i]["code"]);
            },
            title: ListeHeaderPage[i]["title"],
          ),
        const SizedBox(
          width: kPadding,
        ),
      ],
    );
  }
}

class HeaderMenu extends StatelessWidget {
  const HeaderMenu({
    Key? key,
    required this.title,
    required this.press,
  }) : super(key: key);
  final String title;
  final VoidCallback press;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: press,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Text(
          title,
          style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              shadows: [
                Shadow(
                    color: Color.fromARGB(119, 0, 0, 0),
                    offset: Offset(3, 5),
                    blurRadius: 5),
              ]),
        ),
      ),
    );
  }
}

class MobMenu extends StatefulWidget {
  const MobMenu({Key? key}) : super(key: key);

  @override
  _MobMenuState createState() => _MobMenuState();
}

class _MobMenuState extends State<MobMenu> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (int i = 0; ListeHeaderPage.length > i; i++)
            HeaderMenu(
              press: () {
                myNavigator(context, ListeHeaderPage[i]["code"]);
              },
              title: ListeHeaderPage[i]["title"],
            ),
          const SizedBox(
            width: kPadding,
          ),
        ],
      ),
    );
  }
}

// ignore: non_constant_identifier_names
Drawer MyDrawerMenu() {
  return Drawer(
    child: ListView(
      children: [
        DrawerHeader(
          child: Center(
            child: Image.asset(
              logoSite,
              height: 150,
              width: 150,
            ),
            //  Text(
            //   "Assia",
            //   style: TextStyle(
            //       fontSize: 25.0,
            //       fontWeight: FontWeight.w900,
            //       color: kSecondaryColor),
            // ),
          ),
        ),
        MobMenu()
      ],
    ),
  );
}
