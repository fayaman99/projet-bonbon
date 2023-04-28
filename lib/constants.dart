import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:online_food_ordering_web/screens/home/Inscription.dart';
import 'package:online_food_ordering_web/screens/home/MonCompte.dart';
import 'package:online_food_ordering_web/screens/home/DetailAchat.dart';
import 'package:online_food_ordering_web/screens/home/NousContactez.dart';
import 'package:online_food_ordering_web/screens/home/home_screen.dart';
import 'package:online_food_ordering_web/screens/home/Login.dart';
import 'package:online_food_ordering_web/screens/home/shopping_screen.dart';

bool editCommande = false;
String id_commmande_modif = "";
int last_code = 1;
// coleur
const kPrimaryColor =
    Color.fromARGB(255, 254, 218, 243); //primary color of our website
const ColorBtnAnnule = Color.fromARGB(255, 243, 117, 117);
const kSecondaryColor = Color(0xFFfe5722); //secondary color
Color ShoppingButtonColor = Color.fromARGB(255, 255, 255, 255);
const kMaxWidth = 1232.0;
const kPadding = 20.0;
const UniteMonetaire = " €";

// variable global
List OldListProduit = [];
List listeActuelProduit = [];
List listeCommande = [];
List listeFamilles = [];
List<String> listFamillesAray = [];
List Connection = [
  {
    "statut": false,
    "id": "",
    "nom": "",
    "prenom": "",
    "nom_complet": "",
    "email": "",
    "contact": "",
    "voie": "",
    "code_postal": "",
    "province": "",
    "ville": "",
    "pays": "",
    "adresse": "",
    "complement": ""
  }
];
var redirection = "1";
List ListeCommandesClient = [];
List LigneCommande = [];
// back end
// const host = "./api/";
const host = "http://localhost/api/";
const url_get = "${host}read.php";
const url_getMultiple = "${host}readMultiple.php";
const url_add = "${host}add.php";
const url_delete = "${host}delete.php";
const url_login = "${host}login.php";
const url_logout = "${host}logout.php";
const url_inscription = "${host}inscription.php";
const url_contact = "${host}contact.php";
const url_moncompte = "${host}update.php";
const url_anule_command = "${host}anuleCommande.php";

const base_produit = "produit";
const base_familles = "familles";
const base_commande = "commandes";
const base_ligne_commande = "ligne_commandes";

// fonction utilitaire

inputResponsive(value, valInitial) {
  double reponse = valInitial;
  if (value >= 600) {
    reponse = valInitial;
  }
  if (value < 600 && value >= 400) {
    reponse = 300;
  }
  if (value < 400 && value >= 300) {
    reponse = 250;
  }
  if (value < 300 && value >= 250) {
    reponse = 240;
  }
  if (value < 250) {
    reponse = 220;
  }

  return reponse;
}

myStatutCommande(value) {
  switch (value) {
    case 0:
      return const Text(
        "En attente",
        style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
      );
      break;
    case 1:
      return const Text(
        "En cours de préparation",
        style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
      );
      break;
    case 2:
      return const Text(
        "En cours de livraison",
        style: TextStyle(color: Color.fromARGB(255, 7, 65, 255)),
      );
      break;
    case 3:
      return const Text(
        "Livrée",
        style: TextStyle(color: Color.fromARGB(255, 0, 67, 34)),
      );
      break;
    case 4:
      return const Text(
        "Annulée",
        style: TextStyle(color: Color.fromARGB(255, 90, 1, 1)),
      );
      break;
    default:
  }
}

btnResponsive(value) {
  double reponse = 130;
  if (value >= 600) {
    reponse = 130;
  }
  if (value < 600 && value >= 300) {
    reponse = 100;
  }
  if (value < 300) {
    reponse = 40;
  }
  return reponse;
}

fontResponsive(value, valInitial) {
  double reponse = valInitial;
  if (value >= 600) {
    reponse = valInitial;
  }
  if (value < 600 && value >= 250) {
    reponse = valInitial - 4;
  }
  if (value < 250) {
    reponse = valInitial - 6;
    if (valInitial > 20) {
      reponse = 12;
    }
  }
  return reponse;
}

listeFamilleToArray(value) {
  int length = value.length + 1;
  List<String> newlist = List.filled(length, "null", growable: false);
  newlist[0] = "Tout";
  for (var i = 0; i < value.length; i++) {
    newlist[i + 1] = value[i]["libelle_familles"];
  }
  listFamillesAray = newlist;
}

libelleProduitResponsive(value) {
  if (value >= 720) return 170;
  if (value < 720 && value >= 650) return 140;
  if (value < 650 && value >= 600) return 100;
  if (value < 600 && value >= 500) return 80;
  if (value < 360 && value >= 240) return 80;
}

dateFormatter(value) {
  return DateFormat('dd/MM/yyyy').format(DateTime.parse(value));
}

toMonetaire(String value) {
  MoneyFormatter fmf = MoneyFormatter(amount: double.parse(value));
  return fmf.output.nonSymbol;
}

totalTTC_HT(value) {
  double total_ht = 0, total_tva = 0, total_ttc = 0;

  for (var i = 0; i < value.length; i++) {
    total_ht = total_ht +
        (double.parse(value[i]["prix_unitaire_ht"].toString()) *
            double.parse(value[i]["nombre_achat"].toString()));
    total_tva = total_ht * (double.parse(value[i]["taux"]) / 100);
    total_ttc = total_ht + total_tva;
  }

  return [
    {
      "HT": toMonetaire(total_ht.toString()),
      "TTC": toMonetaire(total_ttc.toString())
    }
  ];
  // "Total HT : " +
  //     ) +
  //     UniteMonetaire +
  //     " ,  Total TTC : " +
  //     ) +
  //     UniteMonetaire;
}

List ListeHeaderPage = [
  {
    "title": "Acceuil",
    "code": 1,
  },
  // {
  //   "title": "Boutique",
  //   "code": 2,
  // },
  // {
  //   "title": "Service",
  //   "code": 7,
  // },
  // {
  //   "title": "Historique de mes achats",
  //   "code": 3,
  // },
  {
    "title": "Contact",
    "code": 8,
  },
  {
    "title": "Se connecter",
    "code": 4,
  },
];

myNavigator(context, value) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) {
      switch (value.toString()) {
        case "0":
          // if (last_code != 0) {
          //   last_code = 0;
          return LoginScreen();
          // }else{

          // }
          // return null;

          break;
        // case "1":
        //   return HomeScreen();
        //   break;
        case "1":
          return SoppingScreen();

        case "4":
          if (Connection[0]["statut"] == true) {
            return MonCompteScreen();
          } else {
            redirection = "4";
            return LoginScreen();
          }
          break;
        case "5":
          return DetailAchatScreen();

          break;
        case "6":
          return InscriptionScreen();
          break;
        // case "7":
        //   return NosService();
        //   break;
        case "8":
          return NousContactez();
          break;
        default:
          return HomeScreen();
      }
    }),
  );
}

const logoSite = 'assets/logo/logo.jpg';
const imageLogin = "assets/images/back3.jpg";
const imageContact = "assets/images/contact.png";
const imageHeader = "assets/images/header.jpg";

// homme banner
const textBanner = " ";
const textBanner2 = "Live anover day";
const descriprionBanner =
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.";
const imageBanner = "assets/images/banner.jpg";
const imageHommeBanner = "assets/images/banner.jpg";

// apropos de livraison

List listeLivraison = [
  {
    "image": "assets/images/service-domicile.jpg",
    "title": "Livraison à domicile",
    "description": "Lorem ipsum dolor sit amet,\nconsectetur adipiscing elit, "
  },
  {
    "image": "assets/images/service-quality.jpg",
    "title": "Produit haute qualité",
    "description": "Lorem ipsum dolor sit amet,\nconsectetur adipiscing elit, "
  },
  {
    "image": "assets/images/service-garantie.jpg",
    "title": "Livraison avec garantie",
    "description": "Lorem ipsum dolor sit amet,\nconsectetur adipiscing elit, "
  },
  {
    "image": "assets/images/service-garantie.jpg",
    "title": "Livraison avec garantie",
    "description": "Lorem ipsum dolor sit amet,\nconsectetur adipiscing elit, "
  },
  {
    "image": "assets/images/service-garantie.jpg",
    "title": "Livraison avec garantie",
    "description": "Lorem ipsum dolor sit amet,\nconsectetur adipiscing elit, "
  },
  {
    "image": "assets/images/service-garantie.jpg",
    "title": "Livraison avec garantie",
    "description": "Lorem ipsum dolor sit amet,\nconsectetur adipiscing elit, "
  },
  {
    "image": "assets/images/service-garantie.jpg",
    "title": "Livraison avec garantie",
    "description": "Lorem ipsum dolor sit amet,\nconsectetur adipiscing elit, "
  },
  {
    "image": "assets/images/service-garantie.jpg",
    "title": "Livraison avec garantie",
    "description": "Lorem ipsum dolor sit amet,\nconsectetur adipiscing elit, "
  }
];
