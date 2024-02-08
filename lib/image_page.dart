import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerApp extends StatelessWidget {
  
  GlobalKey<FormState> key = GlobalKey();
  final TextEditingController _textEditingControllerName=TextEditingController();
  final TextEditingController _textEditingControllerQuantity=TextEditingController();
  final CollectionReference _reference = FirebaseFirestore.instance.collection('notes');
  late Stream<QuerySnapshot> _stream;
  String imageUrl = '';

  ImagePickerApp({Key? key}):super(key: key){
    _stream=_reference.snapshots();
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: const Text('image picker'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _textEditingControllerName,
              decoration: const InputDecoration(
                labelText: 'Enter the name of the item',
                border: OutlineInputBorder()
              ),
              
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _textEditingControllerQuantity,
              decoration: const InputDecoration(
                
                hintText: 'Enter the quantity od the item',
                border: OutlineInputBorder()
              ),
              
            ),
          
            IconButton(onPressed: ()async{
        
              //1st: pick image
              ImagePicker imagePicker = ImagePicker();
              XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);
              print('${file?.path}');
        
              if(file==null) return;
              String uniqueFileName = DateTime.now().microsecondsSinceEpoch.toString();
        
              //2nd: upload to firebase storage
              Reference reference = FirebaseStorage.instance.ref();
              Reference referneceDirImage = reference.child('image');
        
              //create a reference for the image to be stored
              Reference referenceImageToUploade = referneceDirImage.child(uniqueFileName);
        
              try{
                await referenceImageToUploade.putFile(File(file.path));
                imageUrl= await referenceImageToUploade.getDownloadURL();
              }catch(e){
                //
              }
        
            }, icon: const Icon(Icons.camera_alt)),
            ElevatedButton(onPressed: () async{
              if(imageUrl.isEmpty){
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('please upload an image')));
                return;
              }
              if(key.currentState!.validate()){
                String itemName = _textEditingControllerName.text;
                String itemQuantity = _textEditingControllerQuantity.text;

                Map<String, String>dataToSend={
                  'nema':itemName,
                  'quantity':itemQuantity,
                  'image':imageUrl,
                };

                _reference.add(dataToSend);
              }
            }, child: const Text('Submit')),
          ],
        ),
      ),
    );
  }
}
