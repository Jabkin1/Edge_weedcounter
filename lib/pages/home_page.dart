import 'package:flutter/material.dart';
import '../gen_l10n/app_localizations.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Color(0xFFD7DAE0)),
              child: Image.asset('assets/logo.png'),
            ),
            ListTile(
              title: Text(l10n.cameraPage),
              onTap: () => Navigator.pushNamed(context, '/camera'),
            ),
            ListTile(
              title: Text(l10n.detections),
              onTap: () {
                _scaffoldKey.currentState?.closeDrawer();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.takePicturesFirst)),
                );
              },
            ),
            ListTile(
              title: Text(l10n.detectionSummary),
              onTap: () {
                _scaffoldKey.currentState?.closeDrawer();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.takePicturesFirst)),
                );
              },
            ),
            ListTile(
              title: Text(l10n.info),
              onTap: () => Navigator.pushNamed(context, '/info'),
            ),
            ListTile(
              title: Text(l10n.settings),
              onTap: () => Navigator.pushNamed(context, '/settings'),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: const Color(0xFFD7DAE0),
        title: null,
        leading: IconButton(
          icon: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(width: 24, height: 3, color: Colors.black),
              const SizedBox(height: 4),
              Container(width: 24, height: 3, color: Colors.black),
              const SizedBox(height: 4),
              Container(width: 24, height: 3, color: Colors.black),
            ],
          ),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        elevation: 0,
      ),
      body: Container(
        color: const Color(0xFFD7DAE0),
        width: double.infinity,
        child: Column(
          children: [
            const Spacer(flex: 2),
            Image.asset('assets/logo.png', width: 300),
            const Spacer(flex: 3),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text(
                l10n.weedCounterVersion,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
