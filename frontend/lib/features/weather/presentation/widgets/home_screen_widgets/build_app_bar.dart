import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../../core/utils/theme/bloc/theme_bloc.dart';

AppBar buildAppBar({
  required int dateTimestamp,
  required BuildContext context,
  required Function() onPressed,
}) {
  final formattedDate = DateFormat('EEEE d, MMMM').format(
    DateTime.fromMillisecondsSinceEpoch(dateTimestamp * 1000),
  );
  return AppBar(
    backgroundColor: Theme.of(context).colorScheme.surface,
    automaticallyImplyLeading: false,
    leading: IconButton(
      icon: Icon(
        Icons.menu,
        color: Theme.of(context).colorScheme.primary,
      ),
      onPressed: onPressed,
    ),
    title: Text(
      formattedDate,
      style: Theme.of(context).textTheme.titleLarge,
    ),
    actions: [
      IconButton(
        icon: Icon(
          Theme.of(context).brightness == Brightness.light
              ? Icons.nightlight_round
              : Icons.wb_sunny,
          color: Theme.of(context).colorScheme.primary,
        ),
        onPressed: () {
          BlocProvider.of<ThemeBloc>(context).add(ChangeThemeEvent());
        },
      ),
    ],
    centerTitle: true,
  );
}
