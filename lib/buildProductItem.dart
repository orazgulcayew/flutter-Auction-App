import 'package:auction/pages/detailspage.dart';
import 'package:flutter/material.dart';

class BuildProductItem extends StatefulWidget {
  final mediaurl;
  final productName;
  final minimumBid;
  final enddate;
  final description;
  final docId;
  BuildProductItem({
    Key? key,
    this.mediaurl,
    this.productName,
    this.minimumBid,
    this.enddate,
    this.description,
    this.docId,
  }) : super(key: key);

  @override
  _BuildProductItemState createState() => _BuildProductItemState();
}

class _BuildProductItemState extends State<BuildProductItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
        child: InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => DetailsPage(
                    heroTag: widget.mediaurl,
                    productName: widget.productName,
                    minimumBid: widget.minimumBid,
                    enddate: widget.enddate,
                    description: widget.description,
                    docId: widget.docId,
                  ),
                ),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                    child: Row(children: [
                  Hero(
                      tag: widget.mediaurl,
                      child: Image.network(widget.mediaurl,
                          fit: BoxFit.cover, height: 100.0, width: 100.0)),
                  SizedBox(width: 10.0),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * .40,
                          child: Text(widget.productName!,
                              style: TextStyle(
                                  fontSize: 17.0, fontWeight: FontWeight.bold)),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * .40,
                          child: Text('Minimum Bid: ' + widget.minimumBid!,
                              style: TextStyle(
                                  fontSize: 15.0, color: Colors.grey)),
                        )
                      ])
                ])),
              ],
            )));
  }
}
