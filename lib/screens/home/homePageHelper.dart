// ignore_for_file: file_names

import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:escaperoom/constants/appcolors.dart';
import 'package:escaperoom/services/firebaseOperation.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePageHelper with ChangeNotifier {
  Widget bottomNavBar(
      BuildContext context, int index, PageController controller) {
    return CustomNavigationBar(
      currentIndex: index,
      bubbleCurve: Curves.bounceIn,
      scaleCurve: Curves.decelerate,
      selectedColor: blueColor,
      unSelectedColor: whiteColor,
      strokeColor: blueColor,
      scaleFactor: 0.5,
      iconSize: 30,
      onTap: (val) {
        index = val;
        controller.jumpToPage(val);
        notifyListeners();
      },
      backgroundColor: const Color(0xFF040307),
      items: [
        CustomNavigationBarItem(icon: const Icon(EvaIcons.home)),
        CustomNavigationBarItem(icon: const Icon(Icons.message_rounded)),
        CustomNavigationBarItem(icon: const Icon(Icons.search)),
        CustomNavigationBarItem(
          icon: CircleAvatar(
            radius: 35,
            backgroundColor: blueGreyColor,
            backgroundImage:
                Provider.of<FirebaseOperation>(context, listen: false)
                            .getInitUserImage !=
                        null
                    ? NetworkImage(
                        Provider.of<FirebaseOperation>(context, listen: false)
                            .getInitUserImage!)
                    : null,
          ),
        ),
      ],
    );
  }
}
