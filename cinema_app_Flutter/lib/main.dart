import 'package:cinema_app/menuItem.dart';
import 'package:cinema_app/settings-page.dart';
import 'package:cinema_app/villes-page.dart';
import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
      home: MyApp(),
      theme: ThemeData(appBarTheme: AppBarTheme(color: Colors.green)),
    ));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final menus = [
    {'title': 'Home', 'icon': Icon(Icons.home), 'page': VillePage()},
    {'title': 'Settings', 'icon': Icon(Icons.settings), 'page': SettingsPage()},
    {
      'title': 'Contact',
      'icon': Icon(Icons.contact_mail),
      'page': SettingsPage()
    }
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cinema Page"),
      ),
      body: Center(
        child: Text("Home cinema..."),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Center(
                child: CircleAvatar(
                  backgroundImage: AssetImage("./images/profile.png"),
                  radius: 20,
                ),
              ),
              decoration: BoxDecoration(
                  gradient:
                      LinearGradient(colors: [Colors.white, Colors.green])),
            ),
            ...this.menus.map((item) {
              return new Column(
                children: [
                  Divider(
                    color: Colors.green,
                  ),
                  MenuItem(item['title'], item['icon'], (context) {
                    Navigator.pop(context);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => item['page']));
                  })
                ],
              );
            })
          ],
        ),
      ),
    );
  }
}
