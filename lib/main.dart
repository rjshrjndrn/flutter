import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// run the app defined in MyApp
void main() {
  runApp(MyApp());
}

// Code for whole app
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        // Starting point of the app.
        home: MyHomePage(),
      ),
    );
  }
}

// Data needed for app to function
// ChangeNotifier can notify other widgets, if the value changes.
class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
  void genNext() {
    current = WordPair.random(); // changes the above variable value, on call.
    notifyListeners(); // Notify the subscribers of the change.
  }

  var favourites = <WordPair>[];

  void toggleFavorite() {
    if (favourites.contains(current)) {
      favourites.remove(current);
    } else {
      favourites.add(current);
    }
    notifyListeners();
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // function updates state when something changes
    // every build method should return a widget or tree of widgets.
    var appState =
        context.watch<MyAppState>(); // watch method: check for state changes
    var pair = appState.current;

    IconData icon;
    if (appState.favourites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // Arrage below widgets in Column layout
          children: [
            // Text('A random AMAZINGGG idea:'), // Sample widget
            BigCard(
              pair: pair, //trailing comma will notify formatter to add new line
            ), // Take the current state, which is wordpair, check line 25
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton.icon(
                  icon: Icon(icon),
                  label: Text('Like'),
                  onPressed: () {
                    print('liked');
                    appState.toggleFavorite();
                  },
                ),
                SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                    onPressed: () {
                      print('button Pressed');
                      appState.genNext();
                    },
                    child: Text('Next')),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    // dart is nullsafe, means you can't call something which probably will have null. ! means "force override the behaviour"
    var style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Card(
      color: theme.colorScheme.primary,
      elevation: 10,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(pair.asLowerCase,
            semanticsLabel: pair.asPascalCase, style: style),
      ),
    );
  }
}
