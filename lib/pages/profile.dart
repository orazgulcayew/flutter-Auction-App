import 'package:auction/buildProductItem.dart';
import 'package:auction/pages/homepage.dart';
import 'package:auction/provider/data.dart';
import 'package:auction/provider/signin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final user = FirebaseAuth.instance.currentUser;
  bool isVisible = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black54,
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text('Profile'),
          centerTitle: true,
          actions: [
            TextButton(
              onPressed: () {
                final provider = Provider.of<SignIn>(context, listen: false);
                provider.logout();
              },
              child: Text(
                'Logout',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                ),
              ),
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0.0),
          child: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            maxRadius: 50,
                            backgroundImage:
                                NetworkImage(user!.photoURL.toString()),
                          ),
                          SizedBox(height: 8),
                          Text(
                            user!.displayName.toString(),
                            style: TextStyle(color: Colors.black),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Email: ' + user!.email.toString(),
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'My Posted items :',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * .30,
                    //width: MediaQuery.of(context).size.width * 3,
                    padding: EdgeInsets.fromLTRB(20, 20, 10, 0.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    ),
                    child: StreamBuilder<QuerySnapshot>(
                      stream: Data.readUserItems(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text('Something went worng');
                        } else if (snapshot.hasData || snapshot.data != null) {
                          return ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              var productInfo =
                                  snapshot.data!.docs[index].data()!;
                              String? docID = snapshot.data!.docs[index].id;
                              String? productname =
                                  snapshot.data!.docs[index].get('productname');
                              String? productdescriptions = snapshot
                                  .data!.docs[index]
                                  .get('productdescription');
                              String? minimumbid =
                                  snapshot.data!.docs[index].get('minimumbid');
                              String mediaurl =
                                  snapshot.data!.docs[index].get('mediaurl');
                              Timestamp? enddate =
                                  snapshot.data!.docs[index].get('enddate');
                              DateTime endDate = enddate!.toDate();
                              String? endtime =
                                  DateFormat("yyyy-MM-dd").format(endDate);
                              print(docID);
                              return BuildProductItem(
                                  mediaurl: mediaurl,
                                  productName: productname,
                                  minimumBid: minimumbid,
                                  enddate: endtime,
                                  description: productdescriptions,
                                  docId: docID);
                            },
                          );
                        }
                        return Center(
                          child: Text('You have no item'),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
