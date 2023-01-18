import 'package:flutter/material.dart';

import '../../sizes/spacings.dart';

class CustomPageScaffold extends StatelessWidget {
  const CustomPageScaffold({
    required String pageTitle,
    required Widget body,
    Widget? floatingActionButton,
    Key? key,
  })  : _pageTitle = pageTitle,
        _body = body,
        _floatingActionButton = floatingActionButton,
        super(key: key);

  final String _pageTitle;
  final Widget _body;
  final Widget? _floatingActionButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_pageTitle),
        elevation: 3,
        shadowColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(Spacings.xs),
        child: _body,
      ),
      floatingActionButton: _floatingActionButton,
    );
  }
}
