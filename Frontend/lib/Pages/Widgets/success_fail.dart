import 'package:flutter/material.dart';

class SuccessWidget extends StatelessWidget {
  final BuildContext context;
  final VoidCallback onDismiss;

  const SuccessWidget(
      {Key? key, required this.context, required this.onDismiss})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Success'),
      content: const SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text('Added successfully!'),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('OK'),
          onPressed: () {
            Navigator.of(context).pop();
            onDismiss();
          },
        ),
      ],
    );
  }
}

class FailWidget extends StatelessWidget {
  final BuildContext context;
  final VoidCallback onDismiss;

  const FailWidget({Key? key, required this.context, required this.onDismiss})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Failed'),
      content: const SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text('Failed. Please try again.'),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('OK'),
          onPressed: () {
            Navigator.of(context).pop();
            onDismiss();
          },
        ),
      ],
    );
  }
}
