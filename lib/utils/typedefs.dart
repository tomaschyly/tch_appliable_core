import 'package:flutter/material.dart';

typedef CallbackWithContext = void Function(BuildContext context);
typedef AsyncVoidCallback = Future<void> Function();
typedef AsyncCallbackWithContext = Future<void> Function(BuildContext context);
