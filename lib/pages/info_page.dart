import 'package:flutter/material.dart';

import '../gen_l10n/app_localizations.dart';
import '../utils/models.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD7DAE0),
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.info),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                AppLocalizations.of(context)!.weedCounterDescription,
                style: const TextStyle(
                  fontSize: 16,
                  fontFamily: 'Ubuntu',
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}