import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MainResponseWindow()),
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
                    String responseBody = fullResponse.body;
                    context
                        .read<MainResponseWindow>()
                        .updateResponseWindow(responseBody);
                  },
                  child: Text('users'),
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                child:
                    Text(Provider.of<MainResponseWindow>(context).responseText),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
