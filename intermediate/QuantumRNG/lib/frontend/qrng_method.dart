import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quantum_rng/frontend/qrng_quick.dart';
import 'dart:convert';
import 'dart:typed_data';

import 'package:quantum_rng/frontend/quantum_bg.dart';

class MethodsOverviewPage extends StatelessWidget {
  final List<Map<String, dynamic>> methods = [
    {
      'id': 'hadamard',
      'name': 'Hadamard',
      'description': 'Quantum superposition',
      'icon': Icons.waves,
      'color': const Color.fromARGB(255, 149, 0, 255),
      'hasQubitControl': true,
    },
    {
      'id': 'bell',
      'name': 'Bell State',
      'description': 'Quantum entanglement',
      'icon': Icons.link,
      'color': const Color.fromARGB(255, 200, 97, 255),
      'hasQubitControl': false,
    },
    {
      'id': 'ghz',
      'name': 'GHZ State',
      'description': 'Multi-qubit entanglement',
      'icon': Icons.group_work,
      'color': const Color.fromARGB(255, 187, 77, 255),
      'hasQubitControl': true,
    },
    {
      'id': 'nist',
      'name': 'NIST',
      'description': 'Cryptographic standards',
      'icon': Icons.verified_user,
      'color': Colors.purple,
      'hasQubitControl': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            _buildHeader(context),
            SizedBox(height: 20),
            // Quick Action Card
            _buildQuickActionCard(context),
            SizedBox(height: 20),
            // Methods Grid
            _buildMethodsGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quantum Random Number Generator',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'True randomness using quantum mechanics',
          style: TextStyle(
            fontSize: 14,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionCard(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 140, 0, 255),
              Color.fromARGB(255, 82, 5, 133)
            ],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(Icons.auto_awesome, color: Colors.white, size: 24),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quick Random',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Generate single number',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RandomNumberGenerator(),
                  ),
                );
              },
              icon: Icon(Icons.rocket_launch_outlined, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMethodsGrid() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Methods',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 12),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 450,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 15.0,
                childAspectRatio: 2,
              ),
              itemCount: methods.length,
              itemBuilder: (context, index) {
                return MethodCard(method: methods[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text('About Quantum RNG'),
        content: Text(
          'Quantum Random Number Generators use quantum phenomena like superposition and entanglement to generate true randomness.',
          style: TextStyle(fontSize: 14, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}

class MethodCard extends StatelessWidget {
  final Map<String, dynamic> method;

  const MethodCard({Key? key, required this.method}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MethodDetailPage(methodId: method['id']),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: method['color'],
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(method['icon'], size: 20, color: Colors.white),
                SizedBox(height: 4),
                Text(
                  method['name'],
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MethodDetailPage extends StatefulWidget {
  final String methodId;

  const MethodDetailPage({Key? key, required this.methodId}) : super(key: key);

  @override
  _MethodDetailPageState createState() => _MethodDetailPageState();
}

class _MethodDetailPageState extends State<MethodDetailPage> {
  Map<String, dynamic>? result;
  bool isLoading = false;
  int shots = 1024;
  int qubits = 1;

  Future<void> generateRandomNumbers() async {
    setState(() {
      isLoading = true;
      result = null;
    });

    try {
      final response = await http.post(
        Uri.parse(
            'https://qrng-backend.onrender.com/api/generate/${widget.methodId}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'shots': shots, 'qubits': qubits}),
      );

      if (response.statusCode == 200) {
        setState(() {
          result = jsonDecode(response.body);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error: ${response.body}'),
          backgroundColor: Colors.red,
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Connection error: $e'),
        backgroundColor: Colors.red,
      ));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  String _getMethodDescription() {
    switch (widget.methodId) {
      case 'hadamard':
        return 'Uses Hadamard gates to create superposition states with equal probability amplitudes.';
      case 'bell':
        return 'Creates entangled qubit pairs using Hadamard and CNOT gates.';
      case 'ghz':
        return 'Extends entanglement to multiple qubits for enhanced verification.';
      case 'nist':
        return 'Applies cryptographic post-processing to meet NIST standards.';
      default:
        return 'Quantum random number generation method.';
    }
  }

  Uint8List _decodeBase64Image(String base64String) {
    // Remove the data:image/png;base64, prefix if present
    final String data = base64String.contains(',')
        ? base64String.split(',').last
        : base64String;
    return base64.decode(data);
  }

  @override
  Widget build(BuildContext context) {
    final method = MethodsOverviewPage().methods.firstWhere(
          (m) => m['id'] == widget.methodId,
          orElse: () => {'hasQubitControl': false},
        );

    final hasQubitControl = method['hasQubitControl'] ?? false;

    return Scaffold(
      appBar: AppBar(
        title: Text('${method['name']} Method'),
        backgroundColor: const Color.fromARGB(78, 255, 255, 255),
        leading: IconButton(
          icon:
              Icon(Icons.arrow_back, color: const Color.fromARGB(255, 0, 0, 0)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: QuantumBackground(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Method Description
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    color: Colors.white.withOpacity(0.95),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.info,
                                  color: const Color.fromARGB(255, 120, 0, 212),
                                  size: 18),
                              SizedBox(width: 8),
                              Text(
                                'Overview',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Text(
                            _getMethodDescription(),
                            style: TextStyle(
                              fontSize: 14,
                              color: const Color.fromARGB(255, 0, 0, 0),
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),

                // Parameter controls
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    color: Colors.white.withOpacity(0.95),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(Icons.tune,
                                  color:
                                      const Color.fromARGB(255, 152, 33, 243),
                                  size: 18),
                              SizedBox(width: 8),
                              Text(
                                'Parameters',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          _buildParameterSlider(
                            'Shots:',
                            shots,
                            100,
                            10000,
                            (value) => setState(() => shots = value.round()),
                          ),
                          if (hasQubitControl)
                            _buildParameterSlider(
                              'Qubits:',
                              qubits,
                              1,
                              8,
                              (value) => setState(() => qubits = value.round()),
                            ),
                          SizedBox(height: 16),
                          Container(
                            width: double.infinity,
                            height: 44,
                            child: ElevatedButton(
                              onPressed:
                                  isLoading ? null : generateRandomNumbers,
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 177, 33, 243),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: isLoading
                                  ? SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                      ),
                                    )
                                  : Text(
                                      'Generate',
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.black),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),

                // Results
                if (result != null) ...[
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Container(
                      color: Colors.white.withOpacity(0.95),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.analytics,
                                    color: Colors.green, size: 18),
                                SizedBox(width: 8),
                                Text(
                                  'Results',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12),

                            // Statistics Row
                            _buildStatisticsRow(),
                            SizedBox(height: 16),

                            // Visualization Image
                            if (result!['visualization'] != null)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Distribution Comparison:',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      border:
                                          Border.all(color: Colors.grey[300]!),
                                    ),
                                    child: Image.memory(
                                      _decodeBase64Image(
                                          result!['visualization']),
                                      fit: BoxFit.contain,
                                      height: 250,
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                ],
                              ),

                            // Sample bits
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Sample Bits:',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[50],
                                    borderRadius: BorderRadius.circular(8),
                                    border:
                                        Border.all(color: Colors.grey[300]!),
                                  ),
                                  child: SelectableText(
                                    result!['random_bits']
                                            ?.take(10)
                                            .join(', ') ??
                                        '',
                                    style: TextStyle(
                                      fontFamily: 'Monospace',
                                      fontSize: 12,
                                      color: Colors.blueGrey[800],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatisticsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStatCard(
            'Entropy', result!['entropy']?.toStringAsFixed(3) ?? 'N/A'),
        _buildStatCard('Total Bits', result!['total_bits']?.toString() ?? '0'),
        _buildStatCard('Shots', shots.toString()),
      ],
    );
  }

  Widget _buildStatCard(String title, String value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 149, 33, 243).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
            color: const Color.fromARGB(255, 149, 33, 243).withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 149, 33, 243),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildParameterSlider(String label, int value, double min, double max,
      Function(double) onChanged) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: TextStyle(
                    fontWeight: FontWeight.w500, color: Colors.black87)),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 149, 33, 243).withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                value.toString(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 163, 33, 243),
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 4),
        Slider(
          value: value.toDouble(),
          min: min,
          max: max,
          divisions: (max - min).toInt(),
          label: value.toString(),
          onChanged: onChanged,
          activeColor: const Color.fromARGB(255, 145, 33, 243),
          inactiveColor: Colors.grey[300],
        ),
        SizedBox(height: 8),
      ],
    );
  }
}
