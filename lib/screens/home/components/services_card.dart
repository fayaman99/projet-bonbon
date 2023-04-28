import 'package:flutter/material.dart';

import '../../../constants.dart';

class ServicesCard extends StatelessWidget {
  ServicesCard({Key? key, required this.isIndex}) : super(key: key);
  bool isIndex = false;

  @override
  Widget build(BuildContext context) {
    int length = isIndex ? 3 : listeLivraison.length;
    return Wrap(
      // ignore: prefer_const_literals_to_create_immutables
      children: [
        for (int i = 0; length > i; i++)
          Services(
              image: listeLivraison[i]["image"],
              title: listeLivraison[i]["title"],
              description: listeLivraison[i]["description"]),
      ],
    );
  }
}

class Services extends StatelessWidget {
  const Services({
    Key? key,
    required this.image,
    required this.title,
    required this.description,
  }) : super(key: key);
  final String image, title, description;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(kPadding),
      child: Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(8.0),
        child: Container(
          padding: const EdgeInsets.all(kPadding / 2),
          width: 300,
          child: Column(
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.asset(
                      image,
                      height: 80,
                      width: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                          fontSize: fontResponsive(
                              MediaQuery.of(context).size.width, 16),
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize:
                      fontResponsive(MediaQuery.of(context).size.width, 12),
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
