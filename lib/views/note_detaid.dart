import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:notes_app_firebase/cubit/note_cubit.dart';
import 'package:notes_app_firebase/views/update_view.dart';

import '../widgets/text_fromfield.dart';

class NoteDetails extends StatefulWidget {
  const NoteDetails({super.key, required this.DocId});
  final String DocId;

  @override
  State<NoteDetails> createState() => _NoteDetailsState();
}

class _NoteDetailsState extends State<NoteDetails> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController titlecontroller = TextEditingController();
  TextEditingController bodycontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NoteCubit, NoteState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        var cubitt = BlocProvider.of<NoteCubit>(context);
        return Scaffold(
          appBar: AppBar(),
          body: cubitt.notedetails.isEmpty
              ? const Center(child: Text('Add Note From Button Down '))
              : ListView.builder(
                  itemCount: cubitt.notedetails.length,
                  itemBuilder: (context, index) {
                    Color color;
                    if (index % 3 == 0) {
                      color = const Color.fromARGB(255, 228, 125, 117);
                    } else if (index % 3 == 1) {
                      color = const Color.fromARGB(255, 216, 116, 208);
                    } else if (index % 3 == 1) {
                      color = const Color.fromARGB(255, 206, 229, 122);
                    } else if (index % 3 == 1) {
                      color = const Color.fromARGB(255, 113, 78, 82);
                    } else if (index % 3 == 1) {
                      color = const Color.fromARGB(255, 122, 229, 126);
                    } else {
                      color = const Color.fromARGB(255, 199, 217, 232);
                    }
                    return state is NoteloadingState
                        ? const CircularProgressIndicator()
                        : InkWell(
                            onTap: () {
                              Get.to(Updateviw(
                                id: cubitt.notedetails[index].id,
                                DocId: widget.DocId,
                                notedetails: cubitt.notedetails[index],
                                color: color,
                              ));
                            },
                            child: Dismissible(
                              key: Key('item-$index'),
                              confirmDismiss: (direction) async {
                                return await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text("Confirm"),
                                      content: const Text(
                                          "Are you sure you want to delete this item?"),
                                      actions: <Widget>[
                                        MaterialButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(true),
                                          child: const Text(
                                            "DELETE",
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                        MaterialButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(false),
                                          child: const Text("CANCEL"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              onDismissed: (direction) {
                                FirebaseFirestore.instance
                                    .collection('category')
                                    .doc(widget.DocId)
                                    .collection('note')
                                    .doc(cubitt.notedetails[index].id)
                                    .delete();
                                if (cubitt.notedetails[index]['url'] !=
                                    'none') {
                                  FirebaseStorage.instance
                                      .refFromURL(
                                          cubitt.notedetails[index]['url'])
                                      .delete();
                                }
                              },
                              child: Card(
                                child: ListTile(
                                    shape: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    tileColor: color,
                                    title: Text(
                                        "${cubitt.notedetails[index]['title']}"),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            "${cubitt.notedetails[index]['body']}"),
                                        if (cubitt.notedetails[index]['url'] !=
                                            'none')
                                          Image.network(
                                            cubitt.notedetails[index]['url'],
                                            height: 100,
                                            width: 100,
                                          )
                                      ],
                                    )),
                              ),
                            ),
                          );
                  }),
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              cubitt.url = null;
              showmodel2(formkey, context, 'Add', 'Add note Title',
                  'Add note Body', titlecontroller, bodycontroller, () {
                if (formkey.currentState!.validate()) {
                  cubitt.addnotedetails(
                    titlecontroller.text,
                    bodycontroller.text,
                    widget.DocId,
                  );
                  cubitt.getnotedetaidata(widget.DocId);
                  Navigator.pop(context);
                }
              }, () async {
                await cubitt.getImageCamera();
              }, cubitt.takin);
            },
          ),
        );
      },
    );
  }
}

Future<dynamic> showmodel2(
    GlobalKey<FormState> formkey,
    BuildContext context,
    String buttontext,
    // NoteCubit cubitt,
    String titlehint,
    String bodyhint,
    TextEditingController titleController,
    TextEditingController bodyController,
    void Function()? onPressed,
    void Function()? onPressedimage,
    bool taken) {
  return showModalBottomSheet(
    //isScrollControlled: true,
    // useRootNavigator: true,
    constraints: BoxConstraints.loose(Size.infinite),
    useSafeArea: false,
    context: context,
    builder: (BuildContext context) {
      return SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            height: MediaQuery.of(context).size.height * .6,
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
                          hintText: titlehint,
                          controller: titleController),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: customTextField(
                          maxlines: 6,
                          autofocus: true,
                          hintText: bodyhint,
                          controller: bodyController),
                    ),
                    ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(
                                taken == false ? Colors.white : Colors.green)),
                        onPressed: onPressedimage,
                        child: const Text('Add Image')),
                    ElevatedButton(
                        onPressed: onPressed, child: Text(buttontext)),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}
