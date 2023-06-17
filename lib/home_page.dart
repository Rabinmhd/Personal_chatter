import 'package:bubble/bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';




class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  
  
  deleteData(id) async {
    await FirebaseFirestore.instance
        .collection("WhatsappChat")
        .doc(id)
        .delete();
  }

  List? message = [];
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    

    return Scaffold(
      appBar: AppBar(
        title: const Column(
          children: [
            Text(style: TextStyle(fontSize: 20), "Rabin"),
            Text(style: TextStyle(fontSize: 15), "Online")
          ],
        ),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
              child: Image.network(
                  "https://cdn.vectorstock.com/i/1000x1000/31/95/user-sign-icon-person-symbol-human-avatar-vector-12693195.webp")),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("WhatsappChat")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.data != null) {
                    var data1 = snapshot.data!.docs;

                    data1.sort((a, b) => DateTime.parse(a.data()["timeSort"])
                        .compareTo(DateTime.parse(b.data()["timeSort"])));
                    return ListView.separated(
                        itemBuilder: (context, index) {
                          var dateTime = data1[index].data()["time"].toDate();
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                                onLongPress: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text("Delete message"),
                                        actions: [
                                          ElevatedButton(
                                              onPressed: () {
                                                setState(() {
                                                  deleteData(snapshot
                                                      .data?.docs[index].id);
                                                });
                                                Navigator.pop(context);
                                              },
                                              child: const Text("delete"))
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Bubble(
                                      nip: BubbleNip.leftTop,
                                      color: const Color.fromARGB(
                                          255, 224, 217, 197),
                                      child: Row(
                                        children: [
                                          Expanded(
                                              flex: 4,
                                              child: Text(
                                                data1[index]
                                                    .data()["msg"]
                                                    .toString(),
                                              )),
                                          Expanded(
                                              flex: 2,
                                              child: Row(mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    DateFormat('hh-mm-a')
                                                        .format(dateTime),
                                                  ),
                                                ],
                                              ))
                                        ],
                                      )),
                                )),
                          );
                        },
                        separatorBuilder: (context, index) => const Divider(),
                        itemCount: data1.length);
                  } else {
                    return const Text("Data is empty");
                  }
                }),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  suffix: InkWell(
                      onTap: () {
                        if (controller.text.isNotEmpty) {
                          setState(() {
                            if (controller.text.isNotEmpty) {
                              message?.add(controller.text);
                              FirebaseFirestore.instance
                                  .collection("WhatsappChat")
                                  .add({
                                "msg": controller.text,
                                "timeSort": DateTime.now().toString(),
                                "time": DateTime.now(),
                              });
                              controller.clear();
                            }
                          });
                        }
                      },
                      child: const Icon(Icons.send))),
            ),
          )
        ],
      ),
    );
  }
}
