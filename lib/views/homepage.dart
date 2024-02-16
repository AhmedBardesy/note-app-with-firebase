import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:notes_app_firebase/cubit/note_cubit.dart';
import 'package:notes_app_firebase/views/login.dart';
import 'package:notes_app_firebase/views/note_detaid.dart';
import 'package:notes_app_firebase/widgets/text_fromfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController name = TextEditingController();
  TextEditingController newname = TextEditingController();
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  
  gettoken() async {
    String? mytoken = await FirebaseMessaging.instance.getToken();
    print('==============================');
    print(mytoken);
  }

  void initState()  {
    gettoken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        actions: [
          IconButton(
              onPressed: () async {
                GoogleSignIn googleSignIn = GoogleSignIn();

                try {
                  await FirebaseAuth.instance.signOut();
                  await googleSignIn.disconnect();
                } catch (e) {
                  print('ERRRRORRRR***********************RRRRRRRR ${e}');
                }
                Get.off(const LoginPage());
              },
              icon: const Icon(Icons.exit_to_app)),
        ],
      ),
      body: BlocConsumer<NoteCubit, NoteState>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubitt = BlocProvider.of<NoteCubit>(context);
          // cubitt.getdata();
          return state is NoteloadingState
              ? const Center(child: CircularProgressIndicator())
              : state is NotefailerState
                  ? const Center(
                      child: Text(
                          'faild to reload \n  Check your internet connection'),
                    )
                  : GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2),
                      itemCount: cubitt.data.length,
                      itemBuilder: (context, index) => InkWell(
                        onTap: () {
                          cubitt.getnotedetaidata(cubitt.data[index].id);
                          Get.to(NoteDetails(
                            DocId: cubitt.data[index].id,
                          ));
                        },
                        onDoubleTap: () {
                          showmodel(formkey, context, 'Update',
                              "${cubitt.data[index]['name']}", newname, () {
                            if (formkey.currentState!.validate()) {
                              FirebaseFirestore.instance
                                  .collection('category')
                                  .doc(cubitt.data[index].id)
                                  .update({'name': newname.text});
                              cubitt.getdata();

                              Navigator.pop(context);
                            }
                          });
                        },
                        onLongPress: () async {
                          await FirebaseFirestore.instance
                              .collection('category')
                              .doc(cubitt.data[index].id)
                              .delete();

                          cubitt.getdata();
                        },
                        child: Card(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(15),
                                child: Image.asset(
                                  'assets/images/folder.png',
                                  height: 100,
                                  width: 100,
                                ),
                              ),
                              Text(
                                "${cubitt.data[index]['name']}",
                                style: const TextStyle(fontSize: 20),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
        },
      ),
      floatingActionButton: BlocConsumer<NoteCubit, NoteState>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubitt = BlocProvider.of<NoteCubit>(context);

          return FloatingActionButton(
            onPressed: () {
              showmodel(
                formkey,
                context,
                'Add',
                'Name',
                name,
                () async {
                  if (formkey.currentState!.validate()) {
                    cubitt.adduser(name.text);

                    Navigator.pop(context);
                  }
                },
              );
            },
            child: const Icon(Icons.add),
          );
        },
      ),
    );
  }
}

Future<dynamic> showmodel(
    GlobalKey<FormState> formkey,
    BuildContext context,
    String buttontext,
    // NoteCubit cubitt,
    String hinttext,
    TextEditingController controller,
    void Function()? onPressed) {
  return showModalBottomSheet(
    // isScrollControlled: true,
    context: context,
    builder: (BuildContext context) {
      return ListView(children: [
        SizedBox(
          height: 200,
          child: Center(
            child: Form(
              key: formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: customTextField(
                        maxlines: 1,
                        autofocus: true,
                        hintText: hinttext,
                        controller: controller),
                  ),
                  ElevatedButton(onPressed: onPressed, child: Text(buttontext)),
                ],
              ),
            ),
          ),
        ),
      ]);
    },
  );
}
