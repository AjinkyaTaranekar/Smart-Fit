import 'dart:async';
import 'dart:convert';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:best_flutter_ui_templates/ui_view/scan_food_view.dart';
import 'package:best_flutter_ui_templates/ui_view/title_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobile_vision/flutter_mobile_vision.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;


import '../app_theme.dart';

class FoodScanner extends StatefulWidget {
  const FoodScanner({Key key, this.animationController}) : super(key: key);

  final AnimationController animationController;
  @override
  _FoodScannerState createState() => _FoodScannerState();
}

class _FoodScannerState extends State<FoodScanner> with TickerProviderStateMixin {
  Animation<double> topBarAnimation;

  List<Widget> listViews = <Widget>[];
  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;
  int _cameraOcr = FlutterMobileVision.CAMERA_BACK;
  bool _autoFocusOcr = true;
  bool _torchOcr = false;
  bool _multipleOcr = true;
  bool _waitTapOcr = true;
  bool _showTextOcr = true;
  Size _previewOcr;
  List<OcrText> _textsOcr = [];
  //Product
  String cardbody = "Please go ahead and scan your item!";
  String type, category, calory, name;

  
  @override
  void initState() {
    FlutterMobileVision.start().then((previewSizes) => setState(() {
          _previewOcr = previewSizes[_cameraOcr].first;
        }));
    BackButtonInterceptor.add(myInterceptor);
      topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: widget.animationController,
            curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn)));
    addAllListData();

    scrollController.addListener(() {
      if (scrollController.offset >= 24) {
        if (topBarOpacity != 1.0) {
          setState(() {
            topBarOpacity = 1.0;
          });
        }
      } else if (scrollController.offset <= 24 &&
          scrollController.offset >= 0) {
        if (topBarOpacity != scrollController.offset / 24) {
          setState(() {
            topBarOpacity = scrollController.offset / 24;
          });
        }
      } else if (scrollController.offset <= 0) {
        if (topBarOpacity != 0.0) {
          setState(() {
            topBarOpacity = 0.0;
          });
        }
      }
    });
    super.initState();
  }
@override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  bool myInterceptor(bool stopDefaultButtonEvent) {
    Navigator.pop(context, '0.0');
    return true;
  }

  List<DropdownMenuItem<int>> _getCameras() {
    List<DropdownMenuItem<int>> cameraItems = [];

    cameraItems.add(new DropdownMenuItem(
      child: new Text('BACK'),
      value: FlutterMobileVision.CAMERA_BACK,
    ));

    cameraItems.add(new DropdownMenuItem(
      child: new Text('FRONT'),
      value: FlutterMobileVision.CAMERA_FRONT,
    ));

    return cameraItems;
  }

  void addAllListData() {
    const int count = 9;
    
    listViews.add(
      TitleView(
        titleTxt: 'Meals today',
        subTxt: 'Add',
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController,
            curve:
                Interval((1 / count) * 0, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController,
      ),
    );
    listViews.add(
      ScanFoodView(
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController,
            curve:
                Interval((1 / count) * 1, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController,
      ),
    );
    listViews.add(
      TitleView(
        titleTxt: 'Which camera would you like to use?',
        subTxt: 'Choose',
        animationController: widget.animationController,
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController,
            curve:
                Interval((1 / count) * 0, 2.0, curve: Curves.fastOutSlowIn))),
      )
    );
    listViews.add(
      chooseCameraButton(
        animationController: widget.animationController,
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController,
            curve:
                Interval((1 / count) * 0, 3.0, curve: Curves.fastOutSlowIn))),
      )
    );
    listViews.add(
      TitleView(
        titleTxt: 'Please turn on torch. \nIf in low light environments',
        animationController: widget.animationController,
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController,
            curve:
                Interval((1 / count) * 0, 4.0, curve: Curves.fastOutSlowIn))),
      )
    );
    listViews.add(
      chooseTorch(
        titleTxt: 'Torch',
        animationController: widget.animationController,
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController,
            curve:
                Interval((1 / count) * 0, 5.0, curve: Curves.fastOutSlowIn))),
      )
    );
    listViews.add(
      scanFoodButton(
        animationController: widget.animationController,
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController,
            curve:
                Interval((1 / count) * 0, 6.0, curve: Curves.fastOutSlowIn))),
      )
    );
    listViews.add(
      displayFoodContent(
        animationController: widget.animationController,
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController,
            curve:
                Interval((1 / count) * 0, 6.0, curve: Curves.fastOutSlowIn))),
      )
    );
                
}
            
Future<bool> getData() async {
  await Future<dynamic>.delayed(const Duration(milliseconds: 50));
  return true;
}

@override
Widget build(BuildContext context) {
  return Container(
    color: AppTheme.background,
    child: Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: <Widget>[
          getMainListViewUI(),
          getAppBarUI(),
          SizedBox(
            height: MediaQuery.of(context).padding.bottom,
          ),
        ],
      ),
    ),
  );
}

Widget getMainListViewUI() {
  return FutureBuilder<bool>(
    future: getData(),
    builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
      if (!snapshot.hasData) {
        return const SizedBox();
      } else {
        return ListView.builder(
          controller: scrollController,
          padding: EdgeInsets.only(
            top: AppBar().preferredSize.height +
                MediaQuery.of(context).padding.top +
                24,
            bottom: 62 + MediaQuery.of(context).padding.bottom,
          ),
          itemCount: listViews.length,
          scrollDirection: Axis.vertical,
          itemBuilder: (BuildContext context, int index) {
            widget.animationController.forward();
            return listViews[index];
          },
        );
      }
    },
  );
}

Widget getAppBarUI() {
  DateTime now = DateTime.now();
  String formattedDate = DateFormat('d MMM').format(now);
  return Column(
    children: <Widget>[
      AnimatedBuilder(
        animation: widget.animationController,
        builder: (BuildContext context, Widget child) {
          return FadeTransition(
            opacity: topBarAnimation,
            child: Transform(
              transform: Matrix4.translationValues(
                  0.0, 30 * (1.0 - topBarAnimation.value), 0.0),
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.white.withOpacity(topBarOpacity),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(32.0),
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: AppTheme.grey
                            .withOpacity(0.4 * topBarOpacity),
                        offset: const Offset(1.1, 1.1),
                        blurRadius: 10.0),
                  ],
                ),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: MediaQuery.of(context).padding.top,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 16,
                          right: 16,
                          top: 46 - 8.0 * topBarOpacity,
                          bottom: 12 - 8.0 * topBarOpacity),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Food Scanner',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontFamily: AppTheme.fontName,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 22 + 6 - 6 * topBarOpacity,
                                  letterSpacing: 1.2,
                                  color: AppTheme.darkerText,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 8,
                              right: 8,
                            ),
                            child: Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: Icon(
                                    Icons.calendar_today,
                                    color: AppTheme.grey,
                                    size: 18,
                                  ),
                                ),
                                Text(
                                  formattedDate,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontFamily: AppTheme.fontName,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 18,
                                    letterSpacing: -0.2,
                                    color: AppTheme.darkerText,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      )
    ],
  );
}
            
Widget scanFoodButton({AnimationController animationController, Animation animation}) {
  return Column(
    children: <Widget>[
      AnimatedBuilder(
        animation: animationController,
        builder: (BuildContext context, Widget child) {
          return FadeTransition(
            opacity: animation,
            child: Transform(
              transform: Matrix4.translationValues(
                  0.0, 30 * (1.0 - animation.value), 0.0),
              child: Container(
                child: Column(
                  children: <Widget>[
                     Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          RaisedButton(
                                 onPressed: read,
                                textColor: Colors.white,
                                padding: const EdgeInsets.all(0.0),
                                child: Container(
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: <Color>[
                                        Color(0xFF0D47A1),
                                        Color(0xFF1976D2),
                                        Color(0xFF42A5F5),
                                      ],
                                    ),
                                  ),
                                  padding: const EdgeInsets.all(10.0),
                                  child: const Text(
                                    'Scan Food',
                                    style: TextStyle(fontSize: 18)
                                  ),
                                ),
                              ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 8,
                              right: 8,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      )
    ],
  );
  }
Widget displayFoodContent({AnimationController animationController, Animation animation}) {
  return Column(
    children: <Widget>[
      AnimatedBuilder(
        animation: animationController,
        builder: (BuildContext context, Widget child) {
          return FadeTransition(
            opacity: animation,
            child: Transform(
              transform: Matrix4.translationValues(
                  0.0, 30 * (1.0 - animation.value), 0.0),
              child: Container(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                          left: 16,
                          right: 16,
                          top: 46 - 8.0 * topBarOpacity,
                          bottom: 12 - 8.0 * topBarOpacity),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Stack(
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    DecoratedBox(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(20.0),
                                            color: Colors.white),
                                        child: Container(
                                          width: (0.8) * MediaQuery.of(context).size.width,
                                          height: 0.43 * MediaQuery.of(context).size.height,
                                          child: Text(cardbody,
                                          style: TextStyle(
                                            fontSize: 25
                                          )),
                                        )),
                                    Container(height: 20.0)
                                  ],
                                ),
                                Column(children: <Widget>[
                                  Container(height: 0.4 * MediaQuery.of(context).size.height),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      FlatButton(
                                        shape: StadiumBorder(),
                                        color: Colors.red,
                                        child: Text("No",
                                            style: TextStyle(color: Colors.white, fontSize: 15)),
                                        onPressed: () => Navigator.pop(context, '0.0'),
                                      ),
                                      SizedBox(
                                        width: 25,
                                      ),
                                      FlatButton(
                                        shape: StadiumBorder(),
                                        color: Colors.blue,
                                        child: Text("Yes",
                                            style: TextStyle(color: Colors.white, fontSize: 15)),
                                        onPressed: () => Navigator.pop(context, calory),
                                      ),
                                    ],
                                  )
                                ])
                              ],
                            ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 8,
                              right: 8,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      )
    ],
  );
  }
Widget chooseTorch({String titleTxt, AnimationController animationController, Animation animation}) {
  return Column(
    children: <Widget>[
      AnimatedBuilder(
        animation: animationController,
        builder: (BuildContext context, Widget child) {
          return FadeTransition(
            opacity: animation,
            child: Transform(
              transform: Matrix4.translationValues(
                  0.0, 30 * (1.0 - animation.value), 0.0),
              child: Container(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                          left: 16,
                          right: 16,
                          top: 46 - 8.0 * topBarOpacity,
                          bottom: 12 - 8.0 * topBarOpacity),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SwitchListTile(
                                title: Text(titleTxt),
                                value: _torchOcr,
                                onChanged: (value) => setState(() => _torchOcr = value),
                            ), 
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 8,
                              right: 8,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      )
    ],
  );
  }
Widget chooseCameraButton({AnimationController animationController, Animation animation}) {
  return Column(
    children: <Widget>[
      AnimatedBuilder(
        animation: animationController,
        builder: (BuildContext context, Widget child) {
          return FadeTransition(
            opacity: animation,
            child: Transform(
              transform: Matrix4.translationValues(
                  0.0, 30 * (1.0 - animation.value), 0.0),
              child: Container(
                child: Column(
                  children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                           new DropdownButton(
                                    items: _getCameras(),
                                    onChanged: (value) {
                                      _previewOcr = null;
                                      setState(() => _cameraOcr = value);
                                    },
                                    value: _cameraOcr,
                                  ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 8,
                              right: 8,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      )
    ],
  );
  }
  Future<Null> read() async {
    List<OcrText> texts = [];
    try {
      texts = await FlutterMobileVision.read(
        flash: _torchOcr,
        autoFocus: _autoFocusOcr,
        multiple: _multipleOcr,
        waitTap: _waitTapOcr,
        showText: _showTextOcr,
        preview: _previewOcr,
        camera: _cameraOcr,
        fps: 2.0,
      );
    } on Exception {
      texts.add(new OcrText('Failed to recognize text.'));
    }

    if (!mounted) return;
    setState(() => _textsOcr = texts);
    for (var items in _textsOcr) getProductData(items.value);
  }

  Future<Null> getProductData(proname) async {
    var response = await http.get(
        Uri.encodeFull("http://192.168.137.1:8080/calories/" + proname),
        headers: {"Accept": "application/json"});
    print(response.body);
    if (response.body != "") {
      setState(() {
        name = jsonDecode(response.body.split(',')[0].split(":")[1]);
        category = jsonDecode(response.body.split(',')[1].split(":")[1]);
        type = jsonDecode(response.body.split(',')[2].split(":")[1]);
        calory = jsonDecode(response.body.split(',')[3].split(":")[1]).toString();
        cardbody = "The item you selected is " +
            name.toUpperCase() +
            ", it belongs to the category of " +
            category +
            ". It has " +
            calory +
            " calories per gram." +
            "Please let us know that are you going to consume this product?";
      });
    }
    print(cardbody);
  }

}