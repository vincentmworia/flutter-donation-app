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
