import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  var directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Hivenosql(),
    );
  }
}
class Hivenosql extends StatefulWidget {
  const Hivenosql({super.key});

  @override
  State<Hivenosql> createState() => _HivenosqlState();
}

class _HivenosqlState extends State<Hivenosql> {
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hive NoSQL'),
      ),
      body: Column(
        children: [
        FutureBuilder(
            future: Hive.openBox('hive box'),
            builder: (context, snapshot) {
              return Column(
                children: [
                  ListTile(
                    title:Text(snapshot.data!.get('name').toString()),
                    trailing:Text(snapshot.data!.get('age').toString(),),),],);
            },),
          FutureBuilder(
            future: Hive.openBox('hive box2'),
            builder: (context, snapshot) {
              return Column(
                children: [
                  ListTile(
                      title: Text(snapshot.data!.get('youtube').toString()
                      ),
                    trailing: IconButton(
                      onPressed: (){
                       snapshot.data!.delete('youtube');
                       setState(() {

                       });
                      },
                      icon: Icon(Icons.edit),
                    ),),],);},)],),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var box = await Hive.openBox('hive box');
          var box2 = await Hive.openBox('hive box2');
          box2.put('youtube', 'anonymous coder');
          box.put('name', 'farwa khan');
          box.put('age', 25);
          box.put('deatils', {
            'cash': 2300,
            'profession': 'developer'
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}


