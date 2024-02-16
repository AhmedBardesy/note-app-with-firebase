// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:notes_app_firebase/views/homepage.dart';

import '../views/login.dart';

part 'note_state.dart';

class NoteCubit extends Cubit<NoteState> {
  NoteCubit() : super(NoteInitialstate());
  List data = [];
  List notedetails = [];
  final FirebaseFirestore firestoreaa = FirebaseFirestore.instance;
  File? file;
  String? url;
  bool takin = false;

  getImageCamera() async {
    url = null;
    final ImagePicker picker = ImagePicker();
    final XFile? imagecamera =
        await picker.pickImage(source: ImageSource.camera);
    if (imagecamera != null) {
      file = File(imagecamera.path);
      var imagename = basename(imagecamera.path);
      print('======================== ${imagename}');
      var refStorage = FirebaseStorage.instance.ref('images').child(imagename);
      await refStorage.putFile(file!);
      url = await refStorage.getDownloadURL();
      takin = true;
    }
  }

  Future adduser(String name) {
    final CollectionReference category = firestoreaa.collection('category');

    return category.add({
      "name": name,
      "id": FirebaseAuth.instance.currentUser!.uid,
    }).then((value) {
      getdata();
      print('#############ADDEDDD##############');
      // ignore: invalid_return_type_for_catch_error
    }).catchError((e) => print("#################ERROR $e"));
  }

  Future addnotedetails(String notetitle, String notebody, String docid) {
    final CollectionReference notedetails =
        firestoreaa.collection('category').doc(docid).collection('note');
    return notedetails.add({
      "title": notetitle,
      "body": notebody,
      "url": url ?? 'none',
    }).then((value) {
      print('############ ADDEDDD details ##############');
      // ignore: invalid_return_type_for_catch_error
    }).catchError((e) => print("#################ERROR $e"));
  }

  getnotedetaidata(String docid) async {
    notedetails = [];
    try {
      emit(NoteloadingState());
      QuerySnapshot response = await FirebaseFirestore.instance
          .collection('category')
          .doc(docid)
          .collection('note')
          .get();
      notedetails = [];

      notedetails.addAll(response.docs);
      print('##########done###########');
      emit(NotesuccessState());
    } on Exception catch (e) {
      emit(NotefailerState());
      // TODO
    }
  }

  getdata() async {
    data = [];
    try {
      emit(NoteloadingState());
      QuerySnapshot response = await FirebaseFirestore.instance
          .collection('category')
          .where('id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();
      data = [];
      data.addAll(response.docs);
      print('##########done###########');
      emit(NotesuccessState());
    } on Exception catch (e) {
      emit(NotefailerState());
      // TODO
    }
  }

  Future signInWithGoogle() async {
    try {
      emit(NoteloadingStatelogin());
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        emit(NoteNotloadingStatelogin());
        return;
      }
      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      await FirebaseAuth.instance.signInWithCredential(credential);
      emit(NotesuccessStatelogin());
      getdata();
      Get.off(const HomePage());
    } on Exception catch (e) {
      emit(NotefailerStatelogin());
      // TODO
    }
  }

  Future<void> EmailPasswordSignin(
      BuildContext context, String email, String password) async {
    try {
      emit(NoteloadingStateloginE());
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      if (FirebaseAuth.instance.currentUser!.emailVerified) {
        emit(NotesuccessStateloginE());
        getdata();
        Get.off(HomePage());
      } else {
        emit(NotefailerStateloginE());
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: const Text('Check Email verification please'),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      emit(NotefailerStateloginE());
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.red, content: Text('User Not found')));
        print('******************************** No user found for that email.');
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.red, content: Text('Wrong Password')));
        print(
            '*********************************Wrong password provided for that user.');
      } else if (e.code == 'invalid-credential') {
        print('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ${e.code}');
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.red, content: Text('invalid credential')));
      } else {
        print('ERROR*********LOGIN************* ${e.code}');
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.red, content: Text('Check again Later')));
      }
    }
  }

  Future CreateEmailPassword(
      BuildContext context, String email, String password) async {
    try {
      emit(NoteloadingStateSignIn());
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (FirebaseAuth.instance.currentUser!.emailVerified == false) {
        emit(NoteNNotloadingStateSignIn());

        showDialog(
          context: context,
          builder: (context) => const AlertDialog(
            content: Text(
                'Please verify your email by clicking the link provided in the email.'),
          ),
        );
        await Future.delayed(Duration(seconds: 2));

        await FirebaseAuth.instance.currentUser!.sendEmailVerification();

        Get.off(const LoginPage());
        emit(NotesuccessStateSignIn());
      } else {
        emit(NotesuccessStateSignIn());
        Get.off(const HomePage());
      }
    } on FirebaseAuthException catch (e) {
      print('ERROR SIGNIN******^^^^^^^^^^^^^^^^^^^^^^^******* ${e.code}');
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Weak Password'),
          backgroundColor: Colors.red,
        ));
        print('********************The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.red,
            content: Text('The account already exists for that email.')));
        print('********************The account already exists for that email.');
      }
      emit(NotefailerStateSignIn());
    }
    //catch (e) {
    //   print(e);
    // }
  }
}
