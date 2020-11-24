import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spag_connect/provider/image_upload_provider.dart';
import 'package:spag_connect/provider/user_provider.dart';
import 'package:spag_connect/resources/auth_methods.dart';
import 'package:spag_connect/screens/home_screen.dart';
import 'package:spag_connect/screens/login_screen.dart';
import 'package:spag_connect/screens/search_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Firebase.inintializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthMethods _authMethods = AuthMethods();
  // FirebaseRepository _repository = FirebaseRepository();
  @override
  Widget build(BuildContext context) {
    // _repository.signOut();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ImageUploadProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        title: "Spag Connect",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(brightness: Brightness.dark),
        initialRoute: '/',
        routes: {
          '/search_screen': (context) => SearchScreen(),
        },
        home: FutureBuilder(
          future: _authMethods.getCurrentUser(),
          builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
            if (snapshot.hasData) {
              return HomeScreen();
            } else {
              return LoginScreen();
            }
          },
        ),
      ),
    );
  }
}
