import 'package:ezpark/core/resposivity/extensions/resizer_extension.dart';
import 'package:flutter/material.dart';

class NoDataFounded extends StatelessWidget {
  const NoDataFounded({required String message, Key? key})
      : _message = message,
        super(key: key);

  final String _message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.sentiment_dissatisfied_outlined,
            color: Theme.of(context).colorScheme.primary,
            size: 40.width,
          ),
          Text(
            _message,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
        ],
      ),
    );
  }
}
