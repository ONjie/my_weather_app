import 'package:flutter/material.dart';

class NavigateToScreenWidget extends StatelessWidget {
  const NavigateToScreenWidget({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });
  final String title;
  final IconData icon;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.labelLarge,
          ),
          Icon(
            icon,
            size: 28,
            color: Theme.of(context).colorScheme.primary,
          ),
        ],
      ),
    );
  }
}
