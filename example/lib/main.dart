import 'package:flutter/material.dart';
import 'package:tch_appliable_core/tch_appliable_core.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return CoreApp(
      title: 'Core Example',
      initializationUi: Container(
        child: Center(
          child: Text(
            'This can be the same as splash\nor\ndifferent custom initialization UI',
            textAlign: TextAlign.center,
          ),
        ),
      ),
      initialScreenRoute: '', //TODO Route
    );
  }
}
