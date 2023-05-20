

import 'package:flutter/material.dart';

import '../utils/globalvariables.dart';

class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({
    required this.webScreenLayout,
    required this.mobileScreenLayout,
  });
final Widget webScreenLayout;
final Widget mobileScreenLayout;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if(constraints.maxWidth>webScreenSize){
return webScreenLayout;
      }
return mobileScreenLayout;
    },);
  }
}
