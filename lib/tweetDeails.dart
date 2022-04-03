import 'package:flutter/material.dart';
import 'package:tpnote/twitterModel.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TwitDetail extends StatefulWidget {
  TwitDetail({Key key, this.twitterModel}) : super(key: key);
  TwitterModel twitterModel;

  @override
  _TwitDetailState createState() => _TwitDetailState();
}

class _TwitDetailState extends State<TwitDetail> with SingleTickerProviderStateMixin,WidgetsBindingObserver{
  FlutterTts flutterTts = FlutterTts();
  AnimationController animationController;
  double scale;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    flutterTts.stop();
  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    animationController = AnimationController(vsync: this,duration: Duration(seconds: 1));
    animationController.forward();

    animationController.addListener(() {
      setState(() {
        scale = animationController.value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text("Twitter sans bdd"),
        actions: [
          Image.asset("assets/images/twitter.png"),
          SizedBox(width: 20),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 20,),
            Transform.scale(
              scale: scale,
              child: SizedBox(
                height: 90,
                width: 90,
                child: ClipOval(
                  child: Image.file(
                    widget.twitterModel.image,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              widget.twitterModel.name,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              widget.twitterModel.description,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              widget.twitterModel.date.toString(),
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
            ),
            SizedBox(
              height: 15,
            ),
            TextButton(onPressed: (){
              flutterTts.setVolume(10000);
              flutterTts.speak(widget.twitterModel.description);

            }, child: Text("read it"))
          ],
        ),
      ),
    ));
  }
}
