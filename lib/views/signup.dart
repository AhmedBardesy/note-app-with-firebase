
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app_firebase/views/login.dart';
import 'package:get/get.dart';
import 'package:notes_app_firebase/widgets/button.dart';
import 'package:notes_app_firebase/widgets/page_description.dart';
import 'package:notes_app_firebase/widgets/text_fromfield.dart';

import '../cubit/note_cubit.dart';
import '../widgets/discription.dart';
import '../widgets/input_description.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController email = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: ListView(children: [
          Form(
            key: formkey,
            child: Column(
              children: [
                const TopIcon(),
                const SizedBox(
                  height: 20,
                ),
                const Page_discription(x: 'SignUp'),
                const Discruption(x: 'SignUP to Continue Using The App'),
                const SizedBox(height: 20),
                const Dis2(x: 'User Name'),
                customTextField(
                  maxlines: 1,
                  autofocus: false,
                  hintText: 'Youe name',
                  controller: username,
                ),
                const SizedBox(height: 10),
                const Dis2(x: 'Email'),
                const SizedBox(height: 10),
                customTextField(
                   maxlines: 1,
                  autofocus: false,
                  hintText: 'Enter Your Email',
                  controller: email,
                ),
                const SizedBox(height: 10),
                const Dis2(x: 'Password'),
                const SizedBox(height: 10),
                customTextField(
                   maxlines: 1,
                  autofocus: false,
                  hintText: 'Enter your Password',
                  controller: password,
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
          const SizedBox(height: 10),
          BlocConsumer<NoteCubit, NoteState>(
            listener: (context, state) {
              // TODO: implement listener
            },
            builder: (context, state) {
              var cubitt = BlocProvider.of<NoteCubit>(context);
              return CustomButton(
                color: Colors.orange,
                function: () async {
                  if (formkey.currentState!.validate()) {
                    await cubitt.CreateEmailPassword(
                        context, email.text, password.text);
                  }
                  print(email.text);
                  print(password.text);
                },
                widget:
                state is NoteloadingStateSignIn ?const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(),
                          ):
                 const Text('Sigup'),
              );
            },
          ),
          const SizedBox(height: 10),
          const SizedBox(height: 10),
          Center(
            child: InkWell(
              onTap: () {
                Get.off(() => const LoginPage(),
                    duration: const Duration(seconds: 1));
              },
              child: const Text.rich(TextSpan(children: [
                TextSpan(text: "Already Have an Account ? "),
                TextSpan(
                    text: "Login",
                    style: TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold))
              ])),
            ),
          )
        ]),
      ),
    );
  }
}
