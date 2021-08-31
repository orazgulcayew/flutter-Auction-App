import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final user = FirebaseAuth.instance.currentUser;

class Data {
  static String? userUid;

  static Future<void> addItem({
    required String? userid,
    required String? productname,
    required String? productdescription,
    required String? minimumbid,
    required DateTime enddate,
    required String mediaurl,
  }) async {
    final CollectionReference mainCollection =
        _firestore.collection('products');

    Map<String, dynamic> value = <String, dynamic>{
      "userid": userid,
      "productname": productname,
      "productdescription": productdescription,
      "minimumbid": minimumbid,
      "enddate": enddate,
      "mediaurl": mediaurl,
      "starttime": DateTime.now(),
    };

    await mainCollection.add(value).whenComplete(() => print('Uploaded'));
  }

  static Future<void> addBid({
    required String? userid,
    required String? docId,
    required String? bid,
    required String? productname,
    required String username,
    int inc = 1,
  }) async {
    final CollectionReference mainCollection = _firestore.collection('bids');

    Map<String, dynamic> value = <String, dynamic>{
      "productname": productname,
      "userid": userid,
      "docid": docId,
      "username": username,
      "bid": bid,
      "starttime": DateTime.now(),
    };

    await mainCollection.add(value).whenComplete(() => print('Uploaded'));
  }

  static Stream<QuerySnapshot> readBids(String? docId) {
    final CollectionReference bidCollection = _firestore.collection('bids');

    return bidCollection.where('docid', isEqualTo: docId).snapshots();
  }

  static Stream<QuerySnapshot> readTotalBids(String? docId) {
    final CollectionReference bidCollection = _firestore.collection('bids');

    return bidCollection.snapshots();
  }

//showing all products
  static Stream<QuerySnapshot> readItems() {
    final CollectionReference productCollection =
        _firestore.collection('products');

    return productCollection.snapshots();
  }

// showing user products
  static Stream<QuerySnapshot> readUserItems() {
    final CollectionReference productCollection =
        _firestore.collection('products');

    return productCollection.where('userid', isEqualTo: user!.uid).snapshots();
  }
}
