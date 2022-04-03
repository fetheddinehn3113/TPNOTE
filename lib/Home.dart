import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tpnote/tweetDeails.dart';
import 'package:tpnote/twitterModel.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<TwitterModel> twittes = [];
  String tweetName = "";
  String tweetDescription = "";
  String error = "";
  bool visible = false;
  File imageFile;
  bool imagePicked = false;

  void takePick() async {
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      visible= false;
      imagePicked = true;
      imageFile = File(image.path);
    }
  }

  tweeter() {
    visible = false;
    if (tweetName.isEmpty) {
      error = "please enter the name";
      visible = true;
      return;
    }
    if (tweetDescription.isEmpty) {
      error = "please enter the description";
      visible = true;
      return;
    }
    if (imageFile == null) {
      error = "please choose a picture";
      visible = true;
      return;
    }
    twittes.add(TwitterModel(
        tweetName, tweetDescription, imageFile, formatDate(DateTime.now())));
    tweetName = "";
    tweetDescription = "";
    imageFile = null;
    imagePicked =false;
    Navigator.pop(context);
    setState(() {});
  }

  formatDate(DateTime dateTime) {
    final DateTime date = dateTime;
    DateFormat formatter = DateFormat('yyyy-MM-dd:HH-mm');
    final String formatted = formatter.format(date);
    return formatted.toString();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text("Twitter sans bdd"),
        actions: [
          InkWell(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (_) =>
                      StatefulBuilder(builder: (context, setState1) {
                        return AlertDialog(
                          insetPadding: EdgeInsets.zero,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextField(
                                onChanged: (String tw) {
                                  tweetName = tw;
                                },
                                decoration: InputDecoration(hintText: "Name"),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              TextField(
                                onChanged: (String tw) {
                                  tweetDescription = tw;
                                },
                                decoration:
                                    InputDecoration(hintText: "Description"),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              TextButton(
                                onPressed: () async {
                                  await takePick();
                                  setState1(() {});
                                },
                                child: Card(
                                  color:
                                      imagePicked ? Colors.orange : Colors.blue,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 20),
                                    child: Center(
                                        child: Text(
                                      imagePicked
                                          ? "image choosed "
                                          : "choose a pic",
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.white),
                                    )),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Visibility(
                                  visible: visible,
                                  child: Text(
                                    error,
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 12),
                                  )),
                              SizedBox(
                                height: 20,
                              ),
                              TextButton(
                                  onPressed: () {
                                    tweeter();
                                    setState1(() {});
                                  },
                                  child: Text(
                                    "Tweeter",
                                    style: TextStyle(fontSize: 19),
                                  ))
                            ],
                          ),
                        );
                      }));
            },
            child: Image.asset("assets/images/twitter.png"),
          ),
          SizedBox(width: 20),
        ],
      ),
      body: ListView.builder(
          itemCount: twittes.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            TwitDetail(twitterModel: twittes[index])));
              },
              onLongPress: () {
                showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                          title: Text("Suppression"),
                          content: Text("Vous confirmez la suppression ?"),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text("Annueler")),
                            TextButton(
                                onPressed: () {
                                  setState(() {
                                    twittes.removeAt(index);
                                    Navigator.pop(context);
                                  });
                                },
                                child: Text("Oui"))
                          ],
                        ));
              },
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  leading: ClipOval(
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Image.file(
                        twittes[index].image,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  title: Text(twittes[index].name),
                  subtitle: Text(twittes[index].description),
                ),
              ),
            );
          }),
    ));
  }
}
