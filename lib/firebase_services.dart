import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseServices {
  // COLLECTION OF LIST
  final CollectionReference userList =
      FirebaseFirestore.instance.collection("UserList");
  // CREATE : add new data
  Future<void> addNewData(String newData) {
    return userList.add({'userData': newData, 'time': Timestamp.now()});
  }

  // READ   : get data from the database
  Stream<QuerySnapshot> getDataStream() {
    final dataStream = userList.orderBy(descending: true, "time").snapshots();
    return dataStream;
  }

  // UPDATE : update data from id
  Future<void> updateData(String docId, String newUserData) {
    return userList
        .doc(docId)
        .update({'userData': newUserData, 'time': Timestamp.now()});
  }

  // DELETE : delete data from id
  Future<void> deleteData(String docId) {
    return userList.doc(docId).delete();
  }
}
