import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseDatabase.instance.useDatabaseEmulator('10.0.2.2', 9000);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isConnected = false;
  String userName = '';

  // This listens to changes in a tree in RTDB
  void listenConnectionChanges() {
    final connectedRef = FirebaseDatabase.instance.ref("info/connected");
    connectedRef.onValue.listen((event) {
      final connected = event.snapshot.value as bool? ?? false;
      if (connected) {
        debugPrint("Connected.");
        setState(() {
          isConnected = true;
        });
      } else {
        debugPrint("Not connected.");
        setState(() {
          isConnected = false;
        });
      }
    });
  }

  void listenUserChanges() {
    FirebaseDatabase.instance.ref('users/12345').onValue.listen((event) {
      debugPrint('data: ${event.snapshot.value}');
      if (event.snapshot.value != null) {
        final map = event.snapshot.value as Map?;
        String name = map?["name"] ?? '';
        setState(() {
          userName = name;
        });
      }
    });
  }

  @override
  void initState() {
    listenConnectionChanges();
    listenUserChanges();
    super.initState();
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
            Text(
              'Connected: $isConnected',
            ),
            Text(
              'Username: $userName',
            ),
          ],
        ),
      ),
    );
  }
}
