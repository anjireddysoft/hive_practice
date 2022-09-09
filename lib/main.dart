import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_practice/user.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Directory directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  Hive.registerAdapter(UserAdapter());
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  Box box;
  List userList = <User>[];

  getData() async {
    box = await Hive.openBox("user");
    setState(() {
      userList = box.values.toList();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              Container(
                child: ListView.builder(
                    itemCount: userList.length,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      User user = userList[index];
                      return Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(user.name),
                                IconButton(
                                    onPressed: () async {
                                      box = await Hive.openBox("user");
                                      setState(() {
                                        box.deleteAt(index);
                                        getData();
                                      });
                                    },
                                    icon: Icon(Icons.delete))
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(user.age),
                                GestureDetector(
                                    onTap: () async {
                                      box = await Hive.openBox("user");
                                      setState(() {
                                        User user = User(
                                            name: nameController.text,
                                            age: ageController.text);
                                        box.putAt(index, user);
                                        getData();
                                      });
                                    },
                                    child: Container(

                                        decoration: BoxDecoration(
                                          color: Colors.blue,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Center(child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text("Update"),
                                        ))))
                              ],
                            ),
                          ],
                        ),
                      );
                    }),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(hintText: "name"),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: ageController,
                    decoration: InputDecoration(hintText: "age"),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  RaisedButton(
                    onPressed: () async {
                      box = await Hive.openBox("user");
                      User user = User(
                          name: nameController.text, age: ageController.text);
                      box.add(user);
                      getData();
                    },
                    child: Text("Add Data"),
                    color: Colors.blue,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
