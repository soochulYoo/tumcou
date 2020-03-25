import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tumcou1/models/customer.dart';
import 'package:tumcou1/models/user.dart';

class ManagerDatabaseService {
  final UserData userData;
  final String barcode;

  ManagerDatabaseService({this.userData, this.barcode});

  Stream<CustomerData> get barcodeData {
    return Firestore.instance
        .collection('Barcode')
        .document(barcode)
        .snapshots()
        .map(_snapshotFromBarcodeData);
  }

  CustomerData _snapshotFromBarcodeData(DocumentSnapshot snapshot) {
    return CustomerData(
      uid: snapshot.data['uid'],
      name: snapshot.data['name'],
      point: snapshot.data['point'],
    );
  }

  setPoint(int point) {
    Firestore.instance.collection('Barcode').document(barcode).updateData({
      "xp": point + 1,
    });
  }
}
