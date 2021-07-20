import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';
import 'package:salons_app_mobile/prezentation/home/home_page.dart';
import 'package:salons_app_mobile/prezentation/login/login_page.dart';

import 'injection_container_app.dart' as appDi;
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  await di.init();
  await appDi.init();

  await initHive();

  runApp(MyApp());
}


Future<void> initHive() async {
  await Hive.initFlutter();
  
  Hive.registerAdapter(SalonAdapter());
  Hive.registerAdapter(MasterAdapter());
  Hive.registerAdapter(ServiceAdapter());
  Hive.registerAdapter(OrderEntityAdapter());

  await getIt<LocalStorage>().openBox();
}


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Salons App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Salons App'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.lightGreen,
//                  image: DecorationImage(
//                      image: AssetImage("images/header.jpeg"),
//                      fit: BoxFit.cover),
              ),
              child: Text("Header"),
            ),
            ListTile(
              title: Text("Home"),
            ),
            ListTile(
              title: Text("Выйти"),
              onTap: () {
                // getIt<LoginBloc>().add(LogoutEvent());
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return new Container(
              color: Colors.white,
            );
          } else {
            if (snapshot.hasData) {
//user is logged in
              return HomePage();
            } else {
//user not logged in
              return LoginPage();
            }
          }
        },
      ),
    );
  }
}
