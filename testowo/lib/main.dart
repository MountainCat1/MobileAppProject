import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:testowo/postList.dart';

import 'catalog.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<Catalog>(
      create: (context) => Catalog(),
      child: MaterialApp(
        title: 'Infinite List Sample',
        theme: ThemeData.dark(useMaterial3: true),
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case '/':
              return SlideTransitionPageRoute(widget: HomeScreen());
            case '/about':
              return SlideTransitionPageRoute(widget: AboutScreen());
            case '/list':
              return SlideTransitionPageRoute(widget: PostList());
            default:
              return null;
          }
        },
      ),
    );
  }
}

class SlideTransitionPageRoute extends PageRouteBuilder {
  final Widget widget;

  SlideTransitionPageRoute({required this.widget})
      : super(
          transitionDuration: const Duration(milliseconds: 200),
          transitionsBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeOut,
              )),
              child: child,
            );
          },
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return widget;
          },
        );
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            HomeNavigationButton(
              onPressed: () {
                Navigator.pushNamed(context, '/list');
              },
              buttonText: 'List',
            ),
            const SizedBox(height: 10), // Optional spacing between buttons
            HomeNavigationButton(
              onPressed: () {
                Navigator.pushNamed(context, '/about');
              },
              buttonText: 'About',
            ),
            const SizedBox(height: 10), // Optional spacing between buttons
            HomeNavigationButton(
              onPressed: () {
                SystemNavigator.pop();
              },
              buttonText: 'Exit',
            ),
          ],
        )));
  }
}

class HomeNavigationButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;

  const HomeNavigationButton({
    required this.buttonText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(buttonText),
      ),
    );
  }
}

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Second Screen'),
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text('Go back'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
