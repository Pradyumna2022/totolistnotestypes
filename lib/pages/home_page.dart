import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todofirelist/firebase_services.dart';
import 'package:todofirelist/pages/login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final firestoreServices = FirebaseServices();
  final _user = FirebaseAuth.instance.currentUser!;
  final dataController = TextEditingController();
  void openListBox({String? docId}) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('New Data'),
              content: TextField(
                controller: dataController,
                decoration: InputDecoration(
                  hintText: 'Enter your Data here',
                ),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (docId == null) {
                      firestoreServices
                          .addNewData(dataController.text.toString());
                    } else {
                      firestoreServices.updateData(
                          docId, dataController.text.toString());
                    }
                    dataController.clear();
                    Navigator.of(context).pop();
                  },
                  child: Text('Save'),
                ),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey.shade100,
          elevation: 0,
          actions: [
            IconButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut().then((value) {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                        (route) => false);
                  });
                },
                icon: Icon(Icons.logout))
          ],
          title: Text(FirebaseAuth.instance.currentUser!.email.toString()),
          centerTitle: true,
        ),
        backgroundColor: Colors.grey.shade100,
        floatingActionButton: FloatingActionButton(
            onPressed: openListBox, child: Icon(Icons.add)),
        body: StreamBuilder(
          stream: firestoreServices.getDataStream(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List userDataList = snapshot.data!.docs;
              return ListView.builder(
                  itemCount: userDataList.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot documentSnapshot = userDataList[index];
                    String docId = documentSnapshot.id;
                    Map<String, dynamic> data =
                        documentSnapshot.data() as Map<String, dynamic>;
                    String dataText = data['userData'];
                    Timestamp timestamp = data['time'];

                    // Convert Timestamp to DateTime
                    DateTime dateTime = timestamp.toDate();

                    // Format DateTime to String
                    String formattedDate =
                        DateFormat('yyyy-MM-dd').format(dateTime);

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        color: Colors.white,
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            title: Text(
                              dataText,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 19),
                            ),
                            subtitle: Text(
                              formattedDate,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 19),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.settings),
                                  onPressed: () => openListBox(docId: docId),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () =>
                                      firestoreServices.deleteData(docId),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  });
            } else {
              return const Text("No data..");
            }
          },
        ));
  }
}
