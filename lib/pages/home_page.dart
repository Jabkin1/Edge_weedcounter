import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
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
              title: const Text('Camera'),
              onTap: () => Navigator.pushNamed(context, '/camera'),
            ),
            ListTile(
              title: const Text('Results'),
              onTap: () => Navigator.pushNamed(context, '/results'),
            ),
            ListTile(
              title: const Text('Summary'),
              onTap: () => Navigator.pushNamed(context, '/summary'),
            ),
            ListTile(
              title: const Text('Info'),
              onTap: () => Navigator.pushNamed(context, '/info'),
            ),
            ListTile(
              title: const Text('Settings'),
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
                'Weed Counter+ version 1.2',
                style: const TextStyle(
                  fontFamily: 'Ubuntu',
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