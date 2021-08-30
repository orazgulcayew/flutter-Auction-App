import 'package:auction/provider/data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DetailsPage extends StatefulWidget {
  final heroTag;
  final productName;
  final minimumBid;
  final enddate;
  final description;
  final docId;

  DetailsPage(
      {this.heroTag,
      this.productName,
      this.minimumBid,
      this.enddate,
      this.description,
      this.docId});

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  String? bid;

  DateTime today = DateTime.now();
  int winner = 0;

  DateTime bidtime = DateTime.now();
  bool isVisible = true;

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    bidtime = DateTime.parse(widget.enddate);

    if (today.year == bidtime.year &&
        today.month == bidtime.month &&
        today.day == bidtime.day) {
      isVisible = true;
    } else if (today.isBefore(bidtime)) {
      isVisible = true;
    } else {
      isVisible = false;
    }
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: ListView(
          //physics: NeverScrollableScrollPhysics(),
          children: [
            //showing product image
            Container(
              height: MediaQuery.of(context).size.height * .30,
              child: Hero(
                tag: widget.heroTag,
                child: Container(
                  child: Image.network(
                    widget.heroTag,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            //product all details
            Container(
              height: MediaQuery.of(context).size.height - 200.0,
              //margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.cyan,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50.0),
                    topRight: Radius.circular(50)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: ListView(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(20, 20, 20, 0.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //name and end date
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        //color: Colors.yellow,
                                        ),
                                    width:
                                        MediaQuery.of(context).size.width * .40,
                                    //height: 100,
                                    child: Text(
                                      widget.productName,
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
                                    width:
                                        MediaQuery.of(context).size.width * .30,
                                    //height: 100,
                                    child: Text(
                                      'End Date: ' + widget.enddate,
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
                                height: 10,
                              ),
                              //minimum bid rate
                              Container(
                                decoration: BoxDecoration(
                                    // color: Colors.yellow,
                                    ),
                                child: Text(
                                  'Minimum Bid: ' + widget.minimumBid,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              //produc description
                              Container(
                                width: MediaQuery.of(context).size.width * 1,
                                child: Text(
                                  'Description: ' + widget.description,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              //bid table
                              Container(
                                width: MediaQuery.of(context).size.width * 1,
                                child: Text(
                                  'Bids Table: ',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              //bid table contents
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                ),
                                width: MediaQuery.of(context).size.width * 1,
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .20,
                                          child: Text('User Name'),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .20,
                                          child: Text('Start Date'),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .20,
                                          child: Text('Bid Amounts'),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              .20,
                                      //width: MediaQuery.of(context).size.width * 3,
                                      padding:
                                          EdgeInsets.fromLTRB(20, 20, 10, 0.0),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                      ),
                                      child: StreamBuilder<QuerySnapshot>(
                                        stream: Data.readBids(widget.docId),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasError) {
                                            return Text('Something went worng');
                                          } else if (snapshot.hasData ||
                                              snapshot.data != null) {
                                            return ListView.builder(
                                              itemCount:
                                                  snapshot.data!.docs.length,
                                              itemBuilder: (context, index) {
                                                String? docID = snapshot
                                                    .data!.docs[index].id;
                                                String? bids = snapshot
                                                    .data!.docs[index]
                                                    .get('bid');
                                                String? productname = snapshot
                                                    .data!.docs[index]
                                                    .get('productname');
                                                String? username = snapshot
                                                    .data!.docs[index]
                                                    .get('username');
                                                Timestamp? startdate = snapshot
                                                    .data!.docs[index]
                                                    .get('starttime');
                                                DateTime date =
                                                    startdate!.toDate();
                                                String? formateddate =
                                                    DateFormat("yyyy-MM-dd")
                                                        .format(date);
                                                List<String> value = [bids!];

                                                print(value);
                                                return Container(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            .20,
                                                        child: Text(username!),
                                                      ),
                                                      Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            .20,
                                                        child:
                                                            Text(formateddate),
                                                      ),
                                                      Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            .20,
                                                        child: Text(bids),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            );
                                          }
                                          return Center(
                                            child: Text('No bids available'),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              //winner
                              Visibility(
                                visible: !isVisible,
                                //maintainSize: true,
                                maintainAnimation: true,
                                maintainState: true,
                                child: Container(
                                  width: MediaQuery.of(context).size.width * 1,
                                  child: Text(
                                    'Winner: ',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),

                              //used for bid field and submit
                              Visibility(
                                visible: isVisible,
                                maintainSize: true,
                                maintainAnimation: true,
                                maintainState: true,
                                child: Center(
                                  child: Form(
                                    key: _formKey,
                                    child: Column(
                                      children: [
                                        //bid form
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .35,
                                          child: TextFormField(
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(),
                                              labelText: 'Bid here',
                                            ),
                                            // The validator receives the text that the user has entered.
                                            validator: (_value) {
                                              if (_value == null ||
                                                  _value.isEmpty) {
                                                return 'Enter value';
                                              }
                                              return null;
                                            },
                                            onChanged: (_value) {
                                              bid = _value;
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        //bid submit button
                                        Container(
                                          height: 40,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .30,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              primary:
                                                  Colors.black26, // background
                                              onPrimary:
                                                  Colors.white, // foreground
                                            ),
                                            onPressed: () async {
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                setState(() {
                                                  isVisible = !isVisible;
                                                });

                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                    content:
                                                        Text('Bid submiting'),
                                                  ),
                                                );
                                                _formKey.currentState!.save();

                                                await Data.addBid(
                                                  productname:
                                                      widget.productName,
                                                  userid: user!.uid,
                                                  username: user!.displayName
                                                      .toString(),
                                                  docId: widget.docId,
                                                  bid: bid,
                                                );
                                              }
                                            },
                                            child: Text('Bid'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
