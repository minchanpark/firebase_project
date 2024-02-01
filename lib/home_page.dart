import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_project/image_page.dart';
import 'package:firebase_project/authentication/auth.dart';
import 'package:firebase_project/services/firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController textEditingController = TextEditingController();
  final FirestoreServise firestoreService = FirestoreServise();

  Future<void> signOut() async {
    await Auth().signOut();
  }

  void openNoteBox({String? docID}) {
    showDialog(
        context: context,
        builder: ((context) => AlertDialog(
              content: TextField(
                controller: textEditingController,
              ),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      if (docID == null) {
                        firestoreService.addNote(textEditingController.text);
                      } else {
                        firestoreService.updateNote(
                            docID, textEditingController.text);
                      }

                      textEditingController.clear();

                      Navigator.pop(context);
                    },
                    child: const Text('Add'))
              ],
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
        actions: [
          ElevatedButton(onPressed: signOut, child: const Text('Logout'))
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (constext) => const ImagePickerApp()));
            },
            child: Text(
              'Next page',
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          FloatingActionButton(
            onPressed: openNoteBox,
            child: const Icon(Icons.add),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: firestoreService.getNotesStream(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List notesList = snapshot.data!.docs;

              return ListView.builder(
                  itemCount: notesList.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot documentSnapshot = notesList[index];
                    String docID = documentSnapshot.id;

                    Map<String, dynamic> data =
                        documentSnapshot.data() as Map<String, dynamic>;
                    String noteText = data['note'];

                    return ListTile(
                      title: Text(noteText),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              onPressed: () {
                                firestoreService.deleteNote(docID);
                              },
                              icon: Icon(Icons.delete)),
                          IconButton(
                              onPressed: () {
                                openNoteBox(docID: docID);
                              },
                              icon: Icon(Icons.settings)),
                        ],
                      ),
                    );
                  });
            } else {
              return const Text('No notes...');
            }
          }),
    );
  }
}
