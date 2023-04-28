import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../constants.dart';

class Footer extends StatelessWidget {
  const Footer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: kPrimaryColor,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(imageHeader),
            fit: BoxFit.cover,
          ),
        ),
        padding: const EdgeInsets.all(kPadding),
        constraints: const BoxConstraints(maxWidth: kMaxWidth),
        child: Column(
          children: [
            Row(
              children: [
                if (MediaQuery.of(context).size.width >= 700)
                  Row(
                    children: [
                      const Text(
                        "Assia Sweet ",
                        style: TextStyle(
                            fontSize: 25.0,
                            fontWeight: FontWeight.w900,
                            color: kSecondaryColor),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          SizedBox(
                            width: 5,
                          ),
                          Text(" Diego-Suarez Antsiranana Madagascar,"),
                        ],
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text(" +261323458188"),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text("christolin99@gmail.com"),
                    ],
                  ),
                if (MediaQuery.of(context).size.width < 700)
                  Row(children: [
                    if (MediaQuery.of(context).size.width < 700 &&
                        MediaQuery.of(context).size.width >= 530)
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 3,
                      ),
                    if (MediaQuery.of(context).size.width < 530 &&
                        MediaQuery.of(context).size.width >= 480)
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 4,
                      ),
                    if (MediaQuery.of(context).size.width < 480 &&
                        MediaQuery.of(context).size.width >= 380)
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 5,
                      ),
                    if (MediaQuery.of(context).size.width < 380 &&
                        MediaQuery.of(context).size.width >= 300)
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 6,
                      ),
                    if (MediaQuery.of(context).size.width < 300)
                      SizedBox(width: MediaQuery.of(context).size.width / 100),
                    Column(
                      children: const [
                        Text(
                          "Assia Sweet ",
                          style: TextStyle(
                              fontSize: 25.0,
                              fontWeight: FontWeight.w900,
                              color: kSecondaryColor),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(" Diego-Suarez Antsiranana"),
                        Text("Madagascar"),
                        Text("+261323458188"),
                        Text("christolin99@gmail.com"),
                      ],
                    ),
                    // SizedBox(
                    //   width: MediaQuery.of(context).size.width * 0.25,
                    // ),
                  ]),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
          ],
        ),
      ),
    );
  }
}
