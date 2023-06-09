import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Channeler',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.green)
            .copyWith(background: Colors.white),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Channeler'),
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
  int _counter = 0;
  List<String> boards = ['Abacus', 'Bonsai', 'Camels'];

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        title: Text(widget.title),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  'Boards',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 26,
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 25,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      child: Text('/a/'),
                    ),
                    title: Text(boards[0]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Your Posts:',
            ),
            Text(
              '$_counter',
              // style: Theme.of(context).textTheme.headline6,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
