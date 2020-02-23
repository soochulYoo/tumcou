//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:rxdart/rxdart.dart';
//import 'package:observable/observable.dart';
//
//class Bloc {
//  //Our local Stream
//  final _documentData = BehaviorSubject<QuerySnapshot>();
//
//  //To listen documents data from StreamBuilder
//  Observable<QuerySnapshot> get documentData => _documentData.stream;
//
//  //Our method we called into init state
//  getAllDocuments() async {
//    QuerySnapshot allDocuments = await _repository.getAllDocuments();
//    //After retrieve all documents, we sink into the pipe (stream)
//    _documentData.sink.add(allDocuments);
//  }
//
////Do not forget to close our stream
//  void dispose() async {
//    await _documentData.drain();
//    _documentData.close();
//  }
//}
