import 'package:flutter/material.dart';

void buildAlertSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(
        duration: Duration(seconds: 3),
        content: Text(text,
            style: TextStyle(color: Theme.of(context).colorScheme.onSecondary)),
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ))
      .closed
      .then((value) => ScaffoldMessenger.of(context).clearSnackBars());
  ;
}
