import 'package:flutter/material.dart';

import '../../../../widget/widget.dart';

class SetupScreen extends StatefulWidget {
  final String code;
  const SetupScreen({super.key, required this.code});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: TextWidget(
          text: 'Setup',
        ),
      ),
    );
  }
}
