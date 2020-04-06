import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:tumcou1/screens/home/posting/posting.dart';

class PostingDatabaseService {
  final int postingId;

  PostingDatabaseService({this.postingId});

  /// 썸네일을 구분지어야 하는가?
  /// 썸네일과 cf를 구분짓고 각각 id를 부여해야 할까?
  ///
  final CollectionReference postingCollection =
      Firestore.instance.collection('Posting');

  Stream<PostingData> get postingData {
    return postingCollection
        .document('posting$postingId')
        .snapshots()
        .map(_postingFromSnapshot);
  }

  PostingData _postingFromSnapshot(DocumentSnapshot snapshot) {
    return PostingData(
      id: snapshot.data['id'],
    );
  }

  ///postingUrl class 는 posting.dart에 적어 놓았다

  Future<PostingUrl> get getpostingUrl async {
    var ref1 = FirebaseStorage.instance
        .ref()
        .child('postingimage/conferences/cfimage$postingId.jpg');
    var ref2 = FirebaseStorage.instance
        .ref()
        .child('postingimage/thumbnail/thumbnailimage$postingId.jpg');

    String cfImageUrl = await ref1.getDownloadURL();
    String thumbnailImageUrl = await ref2.getDownloadURL();
    return PostingUrl(
        cfImageUrl: cfImageUrl, thumbnailImageUrl: thumbnailImageUrl);
  }
}
