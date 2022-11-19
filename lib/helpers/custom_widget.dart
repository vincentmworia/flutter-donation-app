import 'package:flutter/material.dart';

Future<dynamic> customDialog(BuildContext context, String message) async =>
    await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          // title: const Text(''),
          content: Text(message),
          actions: [
            Center(
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Okay')),
            )
          ],
        ));