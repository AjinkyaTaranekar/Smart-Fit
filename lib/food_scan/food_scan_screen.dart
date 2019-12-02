import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:barcode_scan/barcode_scan.dart';

import '../app_theme.dart';

class FoodScanner extends StatefulWidget {
  @override
  _FoodScannerState createState() => _FoodScannerState();
}

class _FoodScannerState extends State<FoodScanner> {
  //Product
  String cardbody = "Please go ahead and scan your item!";
  String type, category, calory, name;

  @override
  void initState() {
    super.initState();
    BackButtonInterceptor.add(myInterceptor);
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

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Food Scan"),
      ),
      body: new Center(
        child: new ListView(
          //mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.all(20.0),
                children: <Widget>[
                  CustomText("Bienvenue !", factor: 2.0,),
                  new Container(
                    alignment: Alignment.center,
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
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Merci à",),
                        FlatButton(
                          padding: EdgeInsets.all(0.0),
                          child: Text("OpenFoodFacts", style: TextStyle(decoration: TextDecoration.underline),),
                          onPressed: _launchOpenFoodFacts,
                        ),
                        Text(" pour leur base de données libre  "),
                        Image.asset('lib/images/openFoodFactsLogo.png', scale: 5.0,),
                      ],
                    ),
                  ),
                  new Container(
                    padding: const EdgeInsets.all(16.0),
                    alignment: Alignment.center,
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
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Flexible(
                          child: Text("Avertissement: la base de données peut être incomplète ou erronnée, elle est maintenue par OpenFoodFacts ainsi que ses utilisateurs.\nVous pouvez aussi y contribuer en corrigeant ou en ajoutant des produits !"),
                        ),
                      ],
                    ),
                  ),
                  new Container(
                    padding: const EdgeInsets.all(16.0),
                    alignment: Alignment.center,
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
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Flexible(
                          child: Text("L'application nécessite d'être connectée au réseau pour fonctionner.\nDans une future version un contrôle sera effectué."),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ]
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.camera_alt),
        label: Text("Scan"),
        onPressed:  _scanQR,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  _launchOpenFoodFacts() async {
    const url = 'https://world.openfoodfacts.org';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
    Future _scanQR() async {
    try {
      String qrResult = await BarcodeScanner.scan();
      setState(() {
        result = qrResult;
        Navigator.push(context, new MaterialPageRoute(
            builder: (BuildContext context) {
              return new Article(url : 'https://world.openfoodfacts.org/api/v0/product/'+result+'.json');
            })
        );
      });
    }
    on PlatformException catch (ex) {
      if (ex.code == BarcodeScanner.CameraAccessDenied) { setState(() { result = "Camera permission was denied"; }); }
      else { setState(() { result = "Unknown Error $ex"; }); }
    }
    on FormatException { setState(() { result = "You pressed the back button before scanning anything"; }); }
    catch (ex) { setState(() { result = "Unknown Error $ex"; }); }
  }
}