import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';

import '../cubit/auth_cubit.dart';
import '../responsive.dart/MobileScreen.dart';
import '../responsive.dart/WebScreen.dart';
import '../responsive.dart/responsive_layout.dart';
import '../utils/Colors.dart';
import '../widgets/text_field_input.dart';
import 'HomeScreen.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is SignupFailedState) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.red, content: Text(state.message)));
        } else if (state is SignupSuccesState) {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeScreen(),));
        }else{
            
          Center(
            child: CircularProgressIndicator(),
          );
          }
      },
      builder: (context, state) {
        final authCubit = BlocProvider.of<AuthCubit>(context);
        return Scaffold(
            body: SafeArea(
                child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 32),
          child: SingleChildScrollView(
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
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
                    height: 24,
                  ),
                  Stack(
                    children: [
                      authCubit.userImgFile != null
                          ? CircleAvatar(
                              radius: 64,
                              backgroundImage:
                                  FileImage(authCubit.userImgFile!),
                            )
                          : CircleAvatar(
                              radius: 64,
                              child: Icon(Icons.person, size: 64),
                            ),
                      Positioned(
                        bottom: -10,
                        right: -5,
                        child: InkWell(
                          onTap: () {
                            authCubit.pickImage(ImageSource.gallery);
                          },
                          child: Icon(Icons.add_a_photo),
                        ),
                      )
                    ],
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
                      hintText: 'Enter your UserName',
                      textInputType: TextInputType.text,
                      textEditingController: _usernameController),
                  SizedBox(
                    height: 24,
                  ),
                  TextFieldInput(
                      hintText: 'Enter your bio',
                      textInputType: TextInputType.text,
                      textEditingController: _bioController),
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
                    onTap: () async {
                      var res = await authCubit.signupuser(
                        file: authCubit.imgurl,
                        bio: _bioController.text,
                        username: _usernameController.text,
                        email: _emailController.text,
                        password: _passwordController.text,
                      );
                      print(res.toString());
                    },
                    child: Container(
                      child: Text('Signup'),
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
                  Flexible(
                    child: Container(),
                    flex: 2,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        child: Container(
                          child: Text('Have already an account'),
                          padding: EdgeInsets.symmetric(vertical: 8),
                        ),
                      ),
                      GestureDetector(onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) =>  ResponsiveLayout(
                    mobileScreenLayout: MobileScreenLayout(),
                    webScreenLayout: WebScreenLayout(),
                  ),));
                      },
                        child: Container(
                          child: Text(
                            'Login in',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              textBaseline: TextBaseline.alphabetic,
                            ),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 8),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        )));
      },
    );
  }
}
