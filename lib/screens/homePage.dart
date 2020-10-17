import 'dart:io';
import 'package:random_color/random_color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';
import 'package:what_s_that_fruit/components/myBtn.dart';

RandomColor _randomColor = RandomColor();
Color _color = _randomColor.randomColor();
Color _color2 = _randomColor.randomColor();

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
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                _color,
                _color2,
              ]),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Center(
              child: _leading
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
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              child: Image.file(_image),
                            ),
                          ),
                          _output == null || _output.isEmpty
                              ? Text('Database Not Found!')
                              : Text(
                                  '$_output',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                  ),
                                )
                        ],
                      ),
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
