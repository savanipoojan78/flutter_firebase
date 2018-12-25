import 'package:flutter/material.dart';
import 'auth.dart' as fauth;
import 'package:async/async.dart';
import 'storage.dart' as fstorage;
import 'package:firebase_core/firebase_core.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';


void main() async
{
  final FirebaseApp firebaseApp=await FirebaseApp.configure(name: 'Firebase', 
      options: new FirebaseOptions(googleAppID: '1:586346947055:android:8571d1565d617280',
      gcmSenderID: '586346947055',
      apiKey:'AIzaSyAK9CeRINpsLJNHm7alGWLgZasdfB7RWT4',
      projectID: 'fir-flutter-b9be4'));
  final FirebaseStorage firebaseStorage=FirebaseStorage(app: firebaseApp,storageBucket: 'gs://fir-flutter-b9be4.appspot.com/');

  runApp(
    new MaterialApp(
    home:new MyApp(storage: firebaseStorage) ,
      debugShowCheckedModeBanner: false,
  ));

 }

class MyApp extends StatefulWidget {
  MyApp({this.storage});
  final FirebaseStorage storage;
  @override
  _State createState() => new _State(storage: storage);




}
class _State extends State<MyApp>
{
  String _status;
  String location;
  _State({this.storage});
  final FirebaseStorage storage;

  @override
  void initState() {
    _status='Not Authenticated';
    _signinGoogle();
  }
  void _upload() async{
    Directory systemTemp=Directory.systemTemp;
    File file = await File('${systemTemp.path}/food.txt').create();
    await file.writeAsString('Hello World');
    String _location=await fstorage.upload(file, basename(file.path));
    setState(() {
      location=_location;
      _status='Uploaded';
    });
  }
  void _download() async
  {
    if(location.isEmpty)
      {
        setState(() {
          _status='Please Upload Something';
        });
      }
      else
        {
          Uri _location=Uri.parse(location);
          String data=await fstorage.download(_location);
          setState(() {
            _status='Downloaded Data';
          });
        }
  }
  void _signinGoogle() async{
    if(await fauth.signIn() == true)
      {
        setState(() {
          _status='Sign IN';
        });
      }
      else{
      _status='Sign In Failed';
    }
    
  }
  void _signout() async
  {
    if(await fauth.signOut()==true)
    setState(() {
      _status='Sign Out';
    });
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        actions: <Widget>[
          new IconButton(icon: new Icon(Icons.settings_power), onPressed: _signout)
        ],
        title: new Text('Flutter APP'),
      ),
      body: new Container(
        padding: new EdgeInsets.all(21.0),
        child: new Column(
          children: <Widget>[
            new Text(_status),
            new Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                new Padding(padding:EdgeInsets.only(top: 200.0) ),
                new RaisedButton(onPressed: _signinGoogle,child: new Text('Sign IN'),),
                new RaisedButton(onPressed: _signout,child: new Text('Sign Out'),)
              ],

            ),

            new Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                new Padding(padding:EdgeInsets.only(top: 300.0) ),
                new RaisedButton(onPressed: _upload,child: new Text('Upload'),),
                new RaisedButton(onPressed: _download,child: new Text('Download'),)

              ],
            ),
          ],
        ),
      ),
    );
  }

}