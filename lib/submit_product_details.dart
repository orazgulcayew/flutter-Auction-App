import 'dart:io';

import 'package:auction/provider/firebase_api.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

import 'package:path/path.dart';
import 'package:auction/provider/data.dart';

class SubmitProductDetails extends StatefulWidget {
  SubmitProductDetails({Key? key}) : super(key: key);

  @override
  _SubmitProductDetailsState createState() => _SubmitProductDetailsState();
}

class _SubmitProductDetailsState extends State<SubmitProductDetails> {
  final firestoreInstance = FirebaseFirestore.instance;
  String? productname;
  String? productdescriptions;
  String? minimumbid;
  UploadTask? task;
  File? file;

  bool isVisible = true;
  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result == null) return;
    final path = result.files.single.path!;

    setState(() {
      file = File(path);
    });
  }

  Future<String> uploadFile() async {
    if (file == null) return 'upload please';

    final fileName = basename(file!.path);
    final destination = 'files/$fileName';

    task = FirebaseApi.uploadFile(destination, file!);
    setState(() {});

    if (task == null) return 'upload please';

    final snapshot = await task!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();

    //print('Download-Link: $urlDownload');
    return urlDownload;
  }

  DateTime date = DateTime.now();

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final fileName = file != null ? basename(file!.path) : 'No File Selected';

    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.cyan, // background
                          onPrimary: Colors.white, // foreground
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.attach_file),
                            SizedBox(width: 10),
                            Text(
                              'Upload Product Image',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                          ],
                        ),
                        onPressed: selectFile,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      fileName,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .10,
                      width: 300,
                      child: TextFormField(
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Product Name',
                        ),
                        // The validator receives the text that the user has entered.
                        validator: (_value) {
                          if (_value == null || _value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        onChanged: (_value) {
                          productname = _value;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .10,
                      width: 300,
                      child: TextFormField(
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Product Description',
                        ),
                        // The validator receives the text that the user has entered.
                        validator: (_value) {
                          if (_value == null || _value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        onChanged: (_value) {
                          productdescriptions = _value;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .10,
                      width: 300,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Minimum Bid Price',
                        ),
                        // The validator receives the text that the user has entered.
                        validator: (_value) {
                          if (_value == null || _value.isEmpty) {
                            return 'Please enter some value';
                          }
                          return null;
                        },
                        onChanged: (_value) {
                          minimumbid = _value;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.cyan, // background
                          onPrimary: Colors.white, // foreground
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.date_range),
                            SizedBox(width: 10),
                            Text(
                              'End Date',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                          ],
                        ),
                        onPressed: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: date,
                            firstDate: date,
                            lastDate: DateTime(2030),
                          );
                          if (picked != null && picked != date) {
                            setState(() {
                              date = picked;
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
                Visibility(
                  visible: isVisible,
                  maintainSize: true,
                  maintainAnimation: true,
                  maintainState: true,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        print('click');
                        // Validate returns true if the form is valid, or false otherwise.
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            isVisible = !isVisible;
                          });
                          // If the form is valid, display a snackbar. In the real world,
                          // you'd often call a server or save the information in a database.
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Wait for back to homepage')),
                          );
                          _formKey.currentState!.save();
                          final user = FirebaseAuth.instance.currentUser;
                          String urlFile = await uploadFile();
                          await Data.addItem(
                              userid: user!.uid,
                              productname: productname,
                              productdescription: productdescriptions,
                              minimumbid: minimumbid,
                              enddate: date,
                              mediaurl: urlFile);

                          Navigator.pop(context);
                        }
                      },
                      child: const Text(
                        'Submit',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
