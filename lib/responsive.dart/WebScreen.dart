import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../cubit/auth_cubit.dart';
import '../utils/Colors.dart';
import '../utils/globalvariables.dart';

class WebScreenLayout extends StatefulWidget {
  const WebScreenLayout({Key? key}) : super(key: key);

  @override
  State<WebScreenLayout> createState() => _WebScreenLayoutState();
}

class _WebScreenLayoutState extends State<WebScreenLayout> {
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
    final user = BlocProvider.of<AuthCubit>(context);
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: mobileBackgroundColor,
            centerTitle: false,
            title: SvgPicture.asset(
              'lib/assets/ic_instagram.svg',
              color: primaryColor,
              height: 32,
            ),
            actions: [
              IconButton(
                onPressed: () {
                  user.navigationTapped(page: 1);
                },
                icon: Icon(Icons.home),
              ),
              IconButton(
                onPressed: () {
                  user.navigationTapped(page: 1);
                },
                icon: Icon(Icons.search),
              ),
              IconButton(
                onPressed: () {
                  user.navigationTapped(page: 2);
                },
                icon: Icon(Icons.add_a_photo),
              ),
              IconButton(
                onPressed: () {
                  user.navigationTapped(page: 3);
                },
                icon: Icon(Icons.favorite),
              ),
              IconButton(
                onPressed: () {
                  user.navigationTapped(page: 4);
                },
                icon: Icon(Icons.person),
              ),
            ],
          ),
          body: PageView(
            physics: NeverScrollableScrollPhysics(),
            children: homeScreenItems,
            controller: user.pagecontroller,
            onPageChanged: (int index) {
              user.changebottomnavindex(index: index);
            },
          ),
        );
      },
    );
  }
}
