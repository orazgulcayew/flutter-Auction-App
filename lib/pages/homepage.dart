import 'package:auction/buildProductItem.dart';
import 'package:auction/provider/signin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:auction/submit_product_details.dart';
import 'package:provider/provider.dart';
import 'package:auction/pages/detailspage.dart';
import 'package:intl/intl.dart';
import 'package:auction/provider/data.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //final firestoreInstance = FirebaseFirestore.instance;
  /*String imgurl =
      'https://images.pexels.com/photos/90946/pexels-photo-90946.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940';
*/
  @override
  Widget build(BuildContext context) {
    //final user = FirebaseAuth.instance.currentUser;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text('Products'),
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
        backgroundColor: Colors.cyan,
        body: ListView(
          children: [
            //create button and logout
            Container(
              height: MediaQuery.of(context).size.height * .15,
              margin: EdgeInsets.all(10),
              child: Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red, // background
                    onPrimary: Colors.white, // foreground
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SubmitProductDetails()),
                    );
                  },
                  child: Text('Create Product'),
                ),
              ),
            ),
            //product lists
            Container(
              height: MediaQuery.of(context).size.height - 185.0,
              padding: EdgeInsets.fromLTRB(20, 20, 10, 0.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(55.0)),
              ),
              child: StreamBuilder<QuerySnapshot>(
                stream: Data.readItems(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went worng');
                  } else if (snapshot.hasData || snapshot.data != null) {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        var productInfo = snapshot.data!.docs[index].data()!;
                        String? docID = snapshot.data!.docs[index].id;
                        String? productname =
                            snapshot.data!.docs[index].get('productname');
                        String? productdescriptions = snapshot.data!.docs[index]
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
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
