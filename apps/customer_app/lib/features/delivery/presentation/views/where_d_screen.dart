import 'package:flutter/material.dart';

import '../widgets/where_destination_body.dart';

class WhereDScreen extends StatelessWidget {
  const WhereDScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: WhereDestinationBody(),
      ),
    );
  }
}