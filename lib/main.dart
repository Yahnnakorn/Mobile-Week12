import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

Future main () async {
   WidgetsFlutterBinding.ensureInitialized() ;
   await Firebase.initializeApp (
      options : DefaultFirebaseOptions.currentPlatform,
   );

   runApp (const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp ({Key? key}) : super(key: key);

  @override
  Widget build ( BuildContext context ) {
     return MaterialApp (
       title : 'Flutter Demo',
       theme : ThemeData (
          colorScheme : ColorScheme.fromSwatch(primarySwatch: Colors.deepPurple),
       ),
       home: const MyHomePage(title: 'Flutter Demo Home Page'),
      );
   }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage ({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState() ;
}

class _MyHomePageState extends State<MyHomePage> {
  final controllerText = TextEditingController();

  void createUser(String name) {
    final docUser = FirebaseFirestore.instance.collection('users').doc(name);

    final json = {'name': name, 'age': 'YourAge', 'birthday': DateTime (2000, 4, 26)};
    
    docUser.set(json);
  }

  @override
  Widget build (BuildContext context) {
    return Scaffold (
       appBar: AppBar (
         backgroundColor: Colors.amber,
         title: TextField(controller: controllerText),
         actions: [
           IconButton(
             icon: Icon(Icons.add),
             onPressed: () {
               final name = controllerText.text;
               createUser(name);
             },
           ),
         ],
       ),
       body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection("users").snapshots(),
          builder: (context, snapshot) {
             if (snapshot.hasData) {
               return ListView.builder (
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: (context, index) {
                     return ListTile(
                        title: Text(snapshot.data?.docs[index]["name"] ?? 'No name'),
                     );
                   },
                );
             } else {
               return Center(child: CircularProgressIndicator());
             }
           }),
     );
   }
}