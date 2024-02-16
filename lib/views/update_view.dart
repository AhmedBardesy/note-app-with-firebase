import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:notes_app_firebase/cubit/note_cubit.dart';
import 'package:notes_app_firebase/widgets/button.dart';

class Updateviw extends StatefulWidget {
  const Updateviw(
      {super.key,
      required this.notedetails,
      required this.color,
      required this.DocId,
      required this.id});
  final notedetails;
  final Color? color;
  final String DocId;
  final String id;
  @override
  State<Updateviw> createState() => _UpdateviwState();
}

class _UpdateviwState extends State<Updateviw> {
  TextEditingController bodyupdate = TextEditingController();
  var formkey = GlobalKey<FormState>();
  String updatedBody = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('${widget.notedetails['title']}'),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 70),
          child: Container(
            width: double.infinity,
            // padding: EdgeInsets.symmetric(vertical: 50),
            decoration: BoxDecoration(
                color: widget.color,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40))),
            child: Form(
              key: formkey,
              child: Column(
                children: [
                  Padding(
                      padding: const EdgeInsets.only(top: 5, left: 5, right: 5),
                      child: TextFormField(
                        onChanged: (value) {
                          updatedBody = value;
                        },
                        initialValue: '${widget.notedetails['body']}',
                        maxLines: 10,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'this field is required';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          enabled: true,
                          hintText: 'update',
                          hintStyle: const TextStyle(color: Colors.grey),
                          fillColor: Colors.grey[200],
                          filled: true,
                          border: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(50)),
                          enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(50)),
                        ),
                      )),
                  BlocConsumer<NoteCubit, NoteState>(
                    listener: (context, state) {
                      // TODO: implement listener
                    },
                    builder: (context, state) {
                      return CustomButton(
                          widget: const Text(
                            'Update',
                            style: TextStyle(color: Colors.black),
                          ),
                          function: () {
                            if (formkey.currentState!.validate()) {
                              try {
                                FirebaseFirestore.instance
                                    .collection('category')
                                    .doc(widget.DocId)
                                    .collection('note')
                                    .doc(widget.id)
                                    .update({'body': updatedBody});
                                BlocProvider.of<NoteCubit>(context)
                                    .getnotedetaidata(widget.DocId);
                                Get.back();
                                print(
                                    '=====================================UPdated');
                              } on Exception catch (e) {
                                print(
                                    '*******************************ERROR IN UPDATE$e');
                              }
                            }
                          },
                          color: Colors.white);
                    },
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
