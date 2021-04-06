import 'package:flutter/material.dart';
import 'package:openid_client/openid_client_browser.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
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
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  TokenResponse tokenResponse;

  void _auth() async {
    // create the client
    var uri = new Uri(scheme: "https", host: "pu-auth.azurewebsites.net");
    var issuer = await Issuer.discover(uri);
    var client = new Client(issuer, "business.flutter.local");

    // create an authenticator
    var authenticator =
        new Authenticator(client, scopes: [
          "openid", 
          "profile",
          "email"
          ]);

    var c = await authenticator.credential;

    if (c == null)
      authenticator.authorize();
    else
      await c.getUserInfo();
  }

  void _callApi() async {
    var url = 'http://192.168.0.100:5010/currencies';
    var access_token = tokenResponse.accessToken;

    var response =
        await http.get(url, headers: {"Authorization": "Bearer $access_token"});
    var body = response.body;
    var a = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _auth,
              child: Text("Login"),
            ),
            ElevatedButton(
              onPressed: _callApi,
              child: Text("Call Api"),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
