import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';
import 'package:what_s_that_fruit/components/myBtn.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:what_s_that_fruit/cons.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _leading = true;
  File _image;
  List _output;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    loadModel().then((value) {
      setState(() {});
    });
  }

  //* load model
  loadModel() async {
    await Tflite.loadModel(
        model: 'assets/tfModel/model.tflite',
        labels: 'assets/tfModel/labels.txt');
  }

//*  clasify Image function
  classifyImage(File image) async {
    var output = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 2,
      threshold: 0.5,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    setState(() {
      _output = output;
      _leading = false;
    });
  }

  //! here's come the real method xD

  pickImage() async {
    print('clicked camera');
    var image = await picker.getImage(source: ImageSource.camera);
    if (image == null) {
      return null;
    }
    setState(() {
      _image = File(image.path);
    });

    classifyImage(_image);
  }

  pickGallery() async {
    print('clicked ga');
    PickedFile image = await picker.getImage(source: ImageSource.gallery);
    if (image == null) {
      return null;
    }
    setState(() {
      _image = File(image.path);
    });
    classifyImage(_image);
  }

// Chnage the Color by the grade
  grade(int num) {
    print(num);
    if (num < 60) {
      return Color(0xFFf53b57);
    } else if (num >= 60 && num < 70) {
      return Color(0xFF4b4b4b);
    } else if (num >= 70 && num < 80) {
      return Color(0xFF7d5fff);
    } else if (num >= 80 && num < 90) {
      return Color(0xFF18dcff);
    } else if (num >= 90) {
      return Color(0xFF32ff7e);
    }
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("What's That Fruit"),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: khomePageGr,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: khomePageGr,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _leading
                ? Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      child: Image.asset('assets/images/hg.png'),
                    ),
                  )
                : Container(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            child: Image.file(_image),
                          ),
                        ),
                        _output == null || _output.isEmpty
                            ? LinearPercentIndicator(
                                alignment: MainAxisAlignment.center,
                                width: MediaQuery.of(context).size.width / 1.2,
                                animation: true,
                                lineHeight: 30,
                                animationDuration: 2000,
                                percent: 0,
                                center: Text("Database not Found!",
                                    style: TextStyle(color: Colors.white)),
                                linearStrokeCap: LinearStrokeCap.roundAll,
                                backgroundColor: Colors.redAccent,
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    '${_output[0]['label']}',
                                    style: TextStyle(
                                      fontSize: 25,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  LinearPercentIndicator(
                                    alignment: MainAxisAlignment.center,
                                    width:
                                        MediaQuery.of(context).size.width / 1.2,
                                    animation: true,
                                    lineHeight: 30,
                                    animationDuration: 2000,
                                    percent: _output[0]['confidence'],
                                    center: Text(
                                        "${(_output[0]['confidence'] * 100).round()}%"),
                                    linearStrokeCap: LinearStrokeCap.roundAll,
                                    //! change COLOR
                                    progressColor: grade(
                                        (_output[0]['confidence'] * 100)
                                            .round()),
                                  ),
                                ],
                              ),
                      ],
                    ),
                  ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                MyBtn(
                  func: () {
                    print('hola');
                    pickImage();
                  },
                  title: 'Camera',
                  icon: CupertinoIcons.camera,
                ),
                MyBtn(
                  func: () {
                    print('hola');
                    pickGallery();
                  },
                  title: 'Gallery',
                  icon: CupertinoIcons.photo_on_rectangle,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
