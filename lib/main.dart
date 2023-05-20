import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instagram/cubit/cubit/user_cubit.dart';
import 'package:instagram/responsive.dart/MobileScreen.dart';
import 'package:instagram/responsive.dart/WebScreen.dart';
import 'package:instagram/responsive.dart/responsive_layout.dart';
import 'package:instagram/utils/Colors.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Constants/constants.dart';
import 'Screens/login_screen.dart';
import 'cubit/auth_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedpref = await SharedPreferences.getInstance();
  Constants.UserId = sharedpref.getString("User ID");
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            storageBucket: "instagram-42cde.appspot.com",
            apiKey: 'AIzaSyBWl7fLoRcSdplt5B-eBD9CM2WU-F-lhPQ',
            appId: '1:489836549423:web:4d57faec763868adc0bdda',
            messagingSenderId: '489836549423',
            projectId: 'instagram-42cde'));
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(create: (_) => AuthCubit()..getUsername()),

        // Add other Cubits here
      ],
      child: MaterialApp(
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: mobileBackgroundColor,
        ),
        debugShowCheckedModeBanner: false,
        home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData) {
                  return ResponsiveLayout(
                    mobileScreenLayout: MobileScreenLayout(),
                    webScreenLayout: WebScreenLayout(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('${snapshot.error}'),
                  );
                }
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                );
              }
              return LoginScreen();
            }),
      ),
    );
  }
}
