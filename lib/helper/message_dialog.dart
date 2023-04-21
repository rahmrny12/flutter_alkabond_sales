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
}

buildLoadingDialog(BuildContext context) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Dialog(
        // The background color
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              // The loading indicator
              CircularProgressIndicator(),
              SizedBox(
                height: 15,
              ),
              // Some text
              Text('Loading...')
            ],
          ),
        ),
      );
    },
  );
}

showConfirmationDialog(
    {required BuildContext context,
    required String text,
    required dynamic Function()? onPressed}) {
  // set up the buttons
  Widget cancelButton = ElevatedButton(
      onPressed: () {
        Navigator.pop(context);
      },
      style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.onPrimary,
          foregroundColor: Theme.of(context).colorScheme.primary,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
              side: BorderSide(
                  width: 2, color: Theme.of(context).colorScheme.primary))),
      child: Text(
        "Batal",
        style: Theme.of(context)
            .textTheme
            .headline6!
            .copyWith(color: Theme.of(context).colorScheme.primary),
      ));
  Widget continueButton = ElevatedButton(
    child: Text("Ya", style: Theme.of(context).textTheme.headline6),
    onPressed: onPressed,
  );
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Konfirmasi",
        style: Theme.of(context)
            .textTheme
            .headline4!
            .copyWith(color: Theme.of(context).colorScheme.onSecondary)),
    content: Text(text,
        style: Theme.of(context)
            .textTheme
            .headline6!
            .copyWith(color: Theme.of(context).colorScheme.onSecondary)),
    actions: [
      cancelButton,
      continueButton,
    ],
  );
  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
