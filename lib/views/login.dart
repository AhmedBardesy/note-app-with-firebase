// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:notes_app_firebase/views/signup.dart';
import 'package:notes_app_firebase/widgets/button.dart';
import 'package:notes_app_firebase/widgets/page_description.dart';
import 'package:notes_app_firebase/widgets/text_fromfield.dart';

import '../cubit/note_cubit.dart';
import '../widgets/discription.dart';
import '../widgets/input_description.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController email = TextEditingController();

  TextEditingController password = TextEditingController();
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(),
          body: BlocConsumer<NoteCubit, NoteState>(
            listener: (context, state) {},
            builder: (context, state) {
              var cubitt = BlocProvider.of<NoteCubit>(context);
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: ListView(children: [
                  Form(
                    key: formkey,
                    child: Column(
                      children: [
                        TopIcon(),
                        SizedBox(
                          height: 20,
                        ),
                        Page_discription(x: 'Login'),
                        Discruption(x: 'Login to Continue Using The App'),
                        SizedBox(height: 20),
                        Dis2(x: 'Email'),
                        SizedBox(height: 10),
                        customTextField(
                           maxlines: 1,
                          autofocus: false,
                          hintText: 'Enter Your Email',
                          controller: email,
                        ),
                        SizedBox(height: 10),
                        Dis2(x: 'Password'),
                        SizedBox(height: 10),
                        customTextField(
                           maxlines: 1,
                          autofocus: false,
                          hintText: 'Enter your Password',
                          controller: password,
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                          style: ButtonStyle(),
                          onPressed: () async {
                            if (email.text == '') {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                    content: Text('Enter your Email First !!')),
                              );
                              return;
                            }

                            await FirebaseAuth.instance
                                .sendPasswordResetEmail(email: email.text);
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                  content: Text('Check Your Email!')),
                            );
                          },
                          child: Text(
                            'Forget password',
                            style: TextStyle(color: Colors.blue),
                          )),
                    ],
                  ),
                  CustomButton(
                    color: Colors.orange,
                    function: () async {
                      if (formkey.currentState!.validate()) {
                        try {
                          await cubitt.EmailPasswordSignin(
                              context, email.text, password.text);
                        } on Exception catch (e) {
                          print('ERRRRRRRRRRRRRRRRRRRRPR ${e}');
                        }
                      }
                    },
                    widget: state is NoteloadingStateloginE
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(),
                          )
                        : Text('Login'),
                  ),
                  const SizedBox(height: 10),
                  CustomButton(
                    color: Colors.red,
                    function: () async {
                      await cubitt.signInWithGoogle();
                    },
                    widget: state is NoteloadingStatelogin
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Login With Google'),
                              Image.asset(
                                'assets/images/google.png',
                                width: 40,
                              )
                            ],
                          ),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: InkWell(
                      onTap: () {
                        Get.off(
                          () => SignUp(),
                        );
                      },
                      child: Text.rich(TextSpan(children: [
                        TextSpan(text: "Don't Have an Account ? "),
                        TextSpan(
                            text: "Sign Up",
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold))
                      ])),
                    ),
                  )
                ]),
              );
            },
          )),
    );
  }
}

class TopIcon extends StatelessWidget {
  const TopIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topRight,
      height: 130,
      width: 130,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 186, 182, 182),
        borderRadius: BorderRadius.circular(42),
        image:
            const DecorationImage(image: AssetImage('assets/images/note.png')),
      ),
    );
  }
}
