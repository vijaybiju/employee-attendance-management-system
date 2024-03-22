import 'package:flutter/material.dart';

class InitialLoading extends StatelessWidget {
  const InitialLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
