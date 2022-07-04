import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:turismoapp/utils/global_variables.dart';

import '../utils/colors.dart';
import '../utils/utils.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({Key? key}) : super(key: key);
  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  
  int _page = 0;
  late PageController pageController; 

  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  void navigationTapped(int page) {
    //Animating Page
    pageController.jumpToPage(page);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        children: homeScreenItems,
        controller: pageController,
        onPageChanged: onPageChanged,
      ),
       bottomNavigationBar: CupertinoTabBar(
              backgroundColor: mobileBackgroundColor,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                    icon: Icon(Icons.home,
                        color: (_page == 0) ? Colors.white : Colors.grey),
                    label: '',
                    backgroundColor: Colors.white),
                BottomNavigationBarItem(
                    icon: Icon(Icons.search,
                        color: (_page == 1) ? Colors.white : Colors.grey),
                    label: '',
                    backgroundColor: Colors.white),
                BottomNavigationBarItem(
                    icon: Icon(Icons.airplanemode_active_outlined,
                        color: (_page == 2) ? Colors.white : Colors.grey),
                    label: '',
                    backgroundColor: Colors.white),
                BottomNavigationBarItem(
                    icon: Icon(Icons.star,
                        color: (_page == 3) ? Colors.white : Colors.grey),
                    label: '',
                    backgroundColor: Colors.white),
                BottomNavigationBarItem(
                    icon: Icon(Icons.person,
                        color: (_page == 4) ? Colors.white : Colors.grey),
                    label: '',
                    backgroundColor: Colors.white),
              ],
              onTap: navigationTapped,
              currentIndex: _page,
            ),
    );
  }
}
