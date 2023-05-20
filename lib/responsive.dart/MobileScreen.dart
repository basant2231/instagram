import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/utils/Colors.dart';
import 'package:instagram/utils/globalvariables.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/cubit/user_cubit.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({super.key});

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}


class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  late AuthCubit authCubit;

  @override
  void initState() {
    super.initState();
    authCubit = BlocProvider.of<AuthCubit>(context);
    authCubit.initializePageController();
  
  }

  @override
  void dispose() {
    authCubit.pagecontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(physics: NeverScrollableScrollPhysics(),
        children:homeScreenItems,
        controller: authCubit.pagecontroller,
        onPageChanged: (int index) {
          authCubit.changebottomnavindex(index: index);
        },
      ),
      bottomNavigationBar: CupertinoTabBar(
        activeColor: Colors.white,
        currentIndex: authCubit.bottomnavindex,
        onTap: (index) {
          authCubit.changebottomnavindex(index: index);
          authCubit.navigationTapped(page: index);
        },
        backgroundColor: mobileBackgroundColor,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: '',
              backgroundColor: primaryColor),
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: '',
              backgroundColor: primaryColor),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_circle),
              label: '',
              backgroundColor: primaryColor),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: '',
              backgroundColor: primaryColor),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: '',
              backgroundColor: primaryColor),
        ],
      ),
    );
  }
}