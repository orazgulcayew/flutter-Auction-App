import 'package:auction/provider/data.dart';
import 'package:auction/provider/signin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _count = 0;
  int complete = 0;
  String? status = 'None';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text('Dashboard'),
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
        body: ListView(
          addAutomaticKeepAlives: true,
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(20, 20, 10, 0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        //color: Colors.yellow,
                        ),
                    width: MediaQuery.of(context).size.width * .40,
                    //height: 100,
                    child: Text(
                      "Running Bids",
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        //color: Colors.green,
                        ),
                    width: MediaQuery.of(context).size.width * .30,
                    //height: 100,
                    child: Text(
                      'Status',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * .5,
              color: Colors.green,
              padding: EdgeInsets.fromLTRB(20, 20, 10, 0.0),
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
                        Timestamp? enddate =
                            snapshot.data!.docs[index].get('enddate');
                        DateTime endDate = enddate!.toDate();
                        String? endtime =
                            DateFormat("yyyy-MM-dd").format(endDate);
                        DateTime today = DateTime.now();
                        if (today.year == endDate.year &&
                            today.month == endDate.month &&
                            today.day == endDate.day) {
                          status = 'Running';
                        } else if (today.isBefore(endDate)) {
                          status = 'Running';
                        } else {
                          status = 'Completed';
                          complete = complete + 1;
                        }

                        _count = index + 1;

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  //color: Colors.yellow,
                                  ),
                              width: MediaQuery.of(context).size.width * .40,
                              //height: 100,
                              child: Text(
                                productname!,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  //color: Colors.green,
                                  ),
                              width: MediaQuery.of(context).size.width * .30,
                              //height: 100,
                              child: Text(
                                status!,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              margin: EdgeInsets.fromLTRB(10, 10, 10, 0.0),
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            //color: Colors.yellow,
                            ),
                        width: MediaQuery.of(context).size.width * .40,
                        //height: 100,
                        child: Text(
                          "Running Bids : " + _count.toString(),
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            //color: Colors.green,
                            ),
                        width: MediaQuery.of(context).size.width * .30,
                        //height: 100,
                        child: Text(
                          ' ',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            //color: Colors.yellow,
                            ),
                        width: MediaQuery.of(context).size.width * .40,
                        //height: 100,
                        child: Text(
                          "Completed Bids : " + complete.toString(),
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            //color: Colors.green,
                            ),
                        width: MediaQuery.of(context).size.width * .30,
                        //height: 100,
                        child: Text(
                          ' ',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
