// import 'package:cloud_firestore/cloud_firestore.dart';

// class FirebaseServices {
//   // COLLECTION OF LIST
//   final CollectionReference userList =
//       FirebaseFirestore.instance.collection("UserList");
//   // CREATE : add new data
//   Future<void> addNewData(String newData) {
//     return userList.add({'userData': newData, 'time': Timestamp.now()});
//   }

//   // READ   : get data from the database
//   Stream<QuerySnapshot> getDataStream() {
//     final dataStream = userList.orderBy(descending: true, "time").snapshots();
//     return dataStream;
//   }

//   // UPDATE : update data from id
//   Future<void> updateData(String docId, String newUserData) {
//     return userList
//         .doc(docId)
//         .update({'userData': newUserData, 'time': Timestamp.now()});
//   }

//   // DELETE : delete data from id
//   Future<void> deleteData(String docId) {
//     return userList.doc(docId).delete();
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseServices {
  final CollectionReference userList =
      FirebaseFirestore.instance.collection("UserList");

  Future<void> addNewData(String newData) {
    final user = FirebaseAuth.instance.currentUser!;
    return userList.add({
      'userData': newData,
      'time': Timestamp.now(),
      'userId': user.uid, // Ensure userId is added
    });
  }

  Stream<QuerySnapshot> getDataStream() {
    final user = FirebaseAuth.instance.currentUser!;
    print("Fetching data for user: ${user.uid}");
    return userList
        .where('userId', isEqualTo: user.uid) // Filter by userId
        .orderBy('time', descending: true)
        .snapshots();
  }

  Future<void> updateData(String docId, String newUserData) {
    return userList.doc(docId).update({
      'userData': newUserData,
      'time': Timestamp.now(),
      'userId':
          FirebaseAuth.instance.currentUser!.uid, // Ensure userId is updated
    });
  }

  Future<void> deleteData(String docId) {
    return userList.doc(docId).delete();
  }
}
