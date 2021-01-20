import 'dart:developer';
import 'dart:io';

import 'package:android_intent/android_intent.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:puffren_app/main_viewmodel.dart';
import 'package:puffren_app/pages/merchant.dart';
import 'package:puffren_app/pages/user.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Puffren Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(title: 'Puffren Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => MainViewModel(),
        child: Consumer<MainViewModel>(
          builder: (_, viewModel, __) {
            return Scaffold(
              appBar: AppBar(
                title: Text(widget.title),
              ),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: 200,
                      color: Colors.grey,
                      child: ListView.builder(
                          // controller: _transController,
                          scrollDirection: Axis.horizontal,
                          itemCount: viewModel.products.length,
                          physics: PageScrollPhysics(
                              parent: BouncingScrollPhysics()),
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 16,
                                horizontal: 8,
                              ),
                              child: Image.network(
                                viewModel.products[index].imgPath,
                                fit: BoxFit.fitHeight,
                                height: 100,
                              ),
                            );
                          }),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20, bottom: 10),
                      child: Text("公告"),
                    ),
                    Expanded(
                      child: ListView.builder(
                          // controller: _transController,
                          itemCount: viewModel.activitys.length,
                          physics: PageScrollPhysics(
                              parent: BouncingScrollPhysics()),
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 5,
                                horizontal: 5,
                              ),
                              child: Container(
                                height: 35,
                                width: double.infinity,
                                child: Row(
                                  children: [
                                    Text(viewModel.activitys[index].title),
                                    SizedBox(width: 20,),
                                    Text(viewModel.activitys[index].content)
                                  ],
                                ),
                              ),
                            );
                          }),
                    ),
                    Container(
                      height: 200,
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                                padding: EdgeInsets.all(10),
                                child: RaisedButton(
                                  onPressed: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return MapPage();
                                    }));
                                  },
                                  child: Text("瀏覽餐車位置"),
                                )),
                            flex: 1,
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: RaisedButton(
                                onPressed: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return MerchantMapPage();
                                  }));
                                },
                                child: Text("登記餐車位置"),
                              ),
                            ),
                            flex: 1,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ));
  }

  @override
  void initState() {
    super.initState();
    test();
    t();
  }

  test() async {
    var location = await Permission.location.status;
    if (!location.isUndetermined) {
      Permission.location.request();
    }
  }

  t() {
    Firestore.instance.collection("products").getDocuments().then((value) {
      log("[getDocuments] value:${value.documents.length}");
      if (value.documents.isNotEmpty) {
        value.documents.map((e) {
          log("[documents] ID:${e.documentID}, data:${e.data.toString()}");
        }).toList();
      }
    });
  }
}
