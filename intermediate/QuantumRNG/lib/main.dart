import 'package:flutter/material.dart';
import 'package:quantum_rng/frontend/benchmark_page.dart';
import 'package:quantum_rng/frontend/learn_page.dart';
import 'package:quantum_rng/frontend/quantum_bg.dart';
import 'frontend/qrng_method.dart';

void main() {
  runApp(QuantumRNGApp());
}

class QuantumRNGApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quantum Random Number Generator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    MethodsOverviewPage(),
    BenchmarkPage(),
    LearnPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Quantum Background covering entire screen
          QuantumBackground(
            child: Container(),
          ),
          // Content on top of background
          Column(
            children: [
              // Transparent AppBar
              AppBar(
                title: Text('Quantum RNG',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            offset: Offset(1.5, 1.5),
                            blurRadius: 3.0,
                            color: const Color.fromARGB(255, 129, 3, 255),
                          ),
                        ])),
                backgroundColor:
                    const Color.fromARGB(95, 0, 0, 0).withOpacity(0.7),
                iconTheme: IconThemeData(color: Colors.white),
              ),
              // Page content
              Expanded(
                child: _pages[_selectedIndex],
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          backgroundColor: Colors.transparent,
          selectedItemColor: const Color.fromARGB(255, 255, 255, 255),
          unselectedItemColor: const Color.fromARGB(179, 194, 190, 190),
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.shuffle), label: 'Methods'),
            BottomNavigationBarItem(
              icon: Icon(Icons.analytics),
              label: 'Benchmark',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.school), label: 'Learn'),
          ],
        ),
      ),
    );
  }
}
