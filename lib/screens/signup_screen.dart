import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:turismoapp/resources/auth_methods.dart';
import 'package:turismoapp/utils/colors.dart';
import 'package:turismoapp/utils/utils.dart';
import 'package:turismoapp/widgets/text_field_input.dart';

import '../responsive/mobile_screen_layout.dart';
import '../responsive/responsive_layout_screen.dart';
import '../responsive/web_screen_layout.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
  }

  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  void signUpUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().signUpUser(
      email: _emailController.text,
      password: _passwordController.text,
      username: _usernameController.text,
      bio: _bioController.text,
    );
    setState(() {
      _isLoading = false;
    });
    if (res != 'success') {
      showSnackBar(res, context, true);
    } else {
      //
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: ((context) => const ResponsiveLayout(
              mobileScreenLayout: MobileScreenLayout(),
              webScreenLayout: WebScreenLayout(),
            )),
      ));
    }
  }

  void navigateToLogin() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
            child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Container(),
                      flex: 1,
                    ),
                    const Image(
                      image: AssetImage('assets/logo_easypc.png'),
                      height: 100,
                    ),
                    Stack(
                      children: [
                        _image != null
                            ? CircleAvatar(
                                radius: 64,
                                backgroundImage: MemoryImage(_image!),
                              )
                            : const CircleAvatar(
                                radius: 64,
                                backgroundImage: NetworkImage(
                                    "https://i.pinimg.com/564x/8f/1b/09/8f1b09269d8df868039a5f9db169a772.jpg"),
                              ),
                        Positioned(
                          bottom: -10,
                          left: 80,
                          child: IconButton(
                            onPressed: () {
                              selectImage();
                            },
                            icon: const Icon(
                              Icons.add_a_photo,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 64),
                    TextFieldInput(
                        textEditingController: _usernameController,
                        hintText: "Ingresa tu nombre de Usuario",
                        textInputType: TextInputType.text),
                    const SizedBox(
                      height: 24,
                    ),
                    TextFieldInput(
                        textEditingController: _emailController,
                        hintText: "Ingresa tu correo",
                        textInputType: TextInputType.emailAddress),
                    const SizedBox(
                      height: 24,
                    ),
                    TextFieldInput(
                      textEditingController: _passwordController,
                      hintText: "Ingresa tu contrase??a",
                      textInputType: TextInputType.text,
                      isPass: true,
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    TextFieldInput(
                        textEditingController: _bioController,
                        hintText: "Ingresa una descripcion",
                        textInputType: TextInputType.multiline),
                    const SizedBox(
                      height: 24,
                    ),
                    InkWell(
                      onTap: signUpUser,
                      child: Container(
                        child: _isLoading
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: primaryColor,
                                ),
                              )
                            : const Text("SignUp"),
                        width: double.infinity,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: const ShapeDecoration(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4))),
                            color: blueColor),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Flexible(
                      child: Container(),
                      flex: 2,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: Text("Ya tienes una cuenta? "),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                        GestureDetector(
                          onTap: navigateToLogin,
                          child: Container(
                            child: const Text(
                              "Login",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                          ),
                        )
                      ],
                    )
                  ],
                ))));
  }
}
