import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instagram/Screens/signupScreen.dart';
import 'package:instagram/utils/Colors.dart';
import 'package:instagram/utils/globalvariables.dart';

import '../cubit/auth_cubit.dart';
import '../responsive.dart/MobileScreen.dart';
import '../responsive.dart/WebScreen.dart';
import '../responsive.dart/responsive_layout.dart';
import '../widgets/text_field_input.dart';
import 'HomeScreen.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authCubit = BlocProvider.of<AuthCubit>(context);
    return BlocConsumer<AuthCubit, AuthState>(
  listener: (context, state) {
    if (state is LoginFailedState) {
      // show a snackbar or toast to inform the user that the login has failed
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.red, content: Text(state.message)));
    } else if (state is LoginSuccessState) {
      // navigate to the home screen
      Navigator.of(context).push(MaterialPageRoute(builder: (context) =>  ResponsiveLayout(
                    mobileScreenLayout: MobileScreenLayout(),
                    webScreenLayout: WebScreenLayout(),
                  ),));
    }
  },
  builder: (context, state) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding:MediaQuery.of(context).size.width>webScreenSize?EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/3): EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: Container(),
                flex: 2,
              ),
              SvgPicture.asset(
                'lib/assets/ic_instagram.svg',
                color: primaryColor,
                height: 64,
              ),
              SizedBox(
                height: 64,
              ),
              TextFieldInput(
                  hintText: 'Enter your email',
                  textInputType: TextInputType.emailAddress,
                  textEditingController: _emailController),
              SizedBox(
                height: 24,
              ),
              TextFieldInput(
                  hintText: 'Enter your password',
                  ispass: true,
                  textInputType: TextInputType.text,
                  textEditingController: _passwordController),
              SizedBox(
                height: 24,
              ),
              GestureDetector(
                onTap: () =>
                    authCubit.login(
                        email: _emailController.text,
                        password: _passwordController.text),
                child: Container(
                  child: state is LoginLoadingState
                          ?
                           Center(
                              child: CircularProgressIndicator(color: primaryColor,),
                            ): Text(
                              'Login',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                textBaseline: TextBaseline.alphabetic,
                              ),
                            ),
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(12),
                  decoration: ShapeDecoration(
                      color: blueColor,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(4)))),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Text('Do not have an account'),
                    padding: EdgeInsets.symmetric(vertical: 8),
                  ),
                  Flexible(
                    child: Container(),
                    flex: 2,
                  ),
                  GestureDetector(
                    onTap: () {
                      // navigate to the sign up screen
                     Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignupScreen()),
                );
                    },
                    child: Container(
                      child: Text('Sign in'),
                      padding: EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ],
              ),
              Flexible(
                child: Container(),
                flex: 2,
              ),
            ],
          ),
        ),
      ),
    );
  },
);

  }
}
