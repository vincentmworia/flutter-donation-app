import 'package:flutter/material.dart';

Container containerStyled(BuildContext ctx) => Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(ctx).colorScheme.primary.withOpacity(0.5),
            Theme.of(ctx).colorScheme.secondary.withOpacity(0.5),
            Theme.of(ctx).colorScheme.secondary..withOpacity(0.5),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: const [0, 1, 3],
        ),
      ),
    );

Future<dynamic> customDialog(BuildContext context, String message) async =>
    await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
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
