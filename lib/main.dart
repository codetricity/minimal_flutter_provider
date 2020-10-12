import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MainResponseWindow()),
        ChangeNotifierProvider(create: (_) => PictureWindow()),
      ],
      child: MyApp(),
    ),
  );
}

class MainResponseWindow with ChangeNotifier {
  String _responseText = "";

  String get responseText => _responseText;

  void updateResponseWindow(response) {
    _responseText = response;
    notifyListeners();
  }
}

class PictureWindow with ChangeNotifier {
  bool _showPicture = false;
  bool get showPicture => _showPicture;

  void togglePicture() {
    _showPicture = !_showPicture;
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('THETA App'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RaisedButton(
                  onPressed: () async {
                    var url = 'https://jsonplaceholder.typicode.com/todos/1';
                    var fullResponse = await http.get(url);
                    String responseBody = fullResponse.body;
                    context
                        .read<MainResponseWindow>()
                        .updateResponseWindow(responseBody);
                  },
                  child: Text('get single todo'),
                ),
                RaisedButton(
                  onPressed: () async {
                    var url = 'https://jsonplaceholder.typicode.com/users';
                    var fullResponse = await http.get(url);
                    print(fullResponse.request);
                    String responseBody = fullResponse.body;
                    context
                        .read<MainResponseWindow>()
                        .updateResponseWindow(responseBody);
                  },
                  child: Text('users'),
                ),
                RaisedButton(
                  onPressed: () {
                    context.read<PictureWindow>().togglePicture();
                  },
                  child: Text('toggle picture'),
                ),
              ],
            ),
            Expanded(
              child: Row(
                children: [
                  Container(
                    width: 400.0,
                    child: SingleChildScrollView(
                      child: Text(Provider.of<MainResponseWindow>(context)
                          .responseText),
                    ),
                  ),
                  Provider.of<PictureWindow>(context).showPicture
                      ? MainPictureWindow()
                      : Container(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MainPictureWindow extends StatelessWidget {
  const MainPictureWindow({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300.0,
      child: ListView(children: [
        Image.network('https://picsum.photos/400/200?random=1'),
        SizedBox(
          height: 12.0,
        ),
        Image.network('https://picsum.photos/400/200?random=2'),
        SizedBox(
          height: 12.0,
        ),
        Image.network('https://picsum.photos/400/200?random=3'),
        SizedBox(
          height: 12.0,
        ),
        Image.network('https://picsum.photos/400/200?random=4'),
        SizedBox(
          height: 12.0,
        ),
        Image.network('https://picsum.photos/400/200?random=5'),
      ]),
    );
  }
}
