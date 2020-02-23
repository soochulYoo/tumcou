import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tumcou1/models/cafe.dart';
import 'package:tumcou1/models/user.dart';
import 'package:random_string/random_string.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DatabaseService {
  final String uid;
  final String barcode;
  int index;

  DatabaseService({
    this.uid,
    this.barcode,
    this.index,
  });

  // collection reference
  final CollectionReference userCollection =
      Firestore.instance.collection('Users');

  final CollectionReference barcodeCollection =
      Firestore.instance.collection('Barcode');

  final CollectionReference cafeCollection =
      Firestore.instance.collection('Cafe');

  Future<String> getCafeImageUrl(int index) async {
    var ref =
        FirebaseStorage.instance.ref().child('cafeimage/cafeimage$index.jpeg');
// no need of the file extension, the name will do fine.
    String url = await ref.getDownloadURL();
    return url;
  }

  Future<String> getCafeLogoImageUrl(int index) async {
    var ref = FirebaseStorage.instance
        .ref()
        .child('cafeimage/cafelogo/cafelogo$index.jpeg');
// no need of the file extension, the name will do fine.
    String url = await ref.getDownloadURL();
    return url;
  }

  Future updateUserData(String name, String grade, int xp, String barcode,
      int age, String gender) async {
    return await userCollection.document(uid).setData({
      'name': name,
      'grade': grade,
      'xp': xp,
      'barcode': barcode,
      'age': age,
      'gender': gender,
    });
  }

  Future generateBarcode() async {
    return '${randomBetween(1000, 9999)}' + randomAlpha(4).toUpperCase();
  }

  Future updateBarCodeData(String uid, String barcode) async {
    return await barcodeCollection.document('barcode').setData({
      uid: barcode,
    }, merge: true);
  }

  // userData fromm snapshot
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      uid: uid,
      name: snapshot.data['name'],
      grade: snapshot.data['grade'],
      xp: snapshot.data['xp'],
      barcode: snapshot.data['barcode'],
      age: snapshot.data['age'],
      gender: snapshot.data['gender'],
    );
  }

  BarcodeData _barcodeDataFromSnapshot(DocumentSnapshot snapshot) {
    return BarcodeData(
      uid: snapshot.data[uid],
      barcode: snapshot.data[barcode],
    );
  }

  CafeData _cafeFromSnapshot(DocumentSnapshot snapshot) {
    return CafeData(
//      category: snapshot.data['category'],
        id: snapshot.data['id'],
        isFeatured: snapshot.data['isFeatured'],
        name: snapshot.data['name'],
        price: snapshot.data['price'],
        introduction: snapshot.data['introduction'],
        location: snapshot.data['location'],
        openingHours: snapshot.data['openingHours']);
  }

  // get user doc stream
  Stream<UserData> get userData {
    return userCollection.document(uid).snapshots().map(_userDataFromSnapshot);
  }

  Stream<CafeData> get cafeData {
    return cafeCollection
        .document('cafe$index')
        .snapshots()
        .map(_cafeFromSnapshot);
  }

  //get review documents
  Future<QuerySnapshot> getAllDocuments(int index) async {
    return Firestore.instance
        .collection('Cafe')
        .document('cafe$index')
        .collection('review')
        .getDocuments();
  }
}
//
//  // brew list from snapshot
//  List<Brew> _brewListFromSnapshot(QuerySnapshot snapshot) {
//    return snapshot.documents.map((doc) {
//      return Brew(
//        name: doc.data['name'] ?? '',
//        strength: doc.data['strength'] ?? 0,
//        sugars: doc.data['sugars'] ?? '0'
//      );
//    }).toList();
//  }
//
//
//  // get brews stream
//  Stream<List<Brew>> get brews {
//    return brewCollection.snapshots()
//        .map(_brewListFromSnapshot);
//  }
//
//  // userData from snapshot
//  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
//    return UserData(
//      uid: uid,
//      name: snapshot.data['name'],
//      sugars: snapshot.data['sugars'],
//      strength: snapshot.data['strength'],
//    );
//  }
//
//  // get user doc stream
//  Stream<UserData> get userData {
//    return brewCollection.document(uid).snapshots()
//        .map(_userDataFromSnapshot);
//  }
//
