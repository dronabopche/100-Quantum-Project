import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

import 'package:quantum_rng/frontend/quantum_bg.dart';

class RandomNumberGenerator extends StatefulWidget {
  @override
  _RandomNumberGeneratorState createState() => _RandomNumberGeneratorState();
}

class _RandomNumberGeneratorState extends State<RandomNumberGenerator> {
  int? _randomNumber;
  bool _isGenerating = false;
  bool _useQuantum = true;
  int _minValue = 0;
  int _maxValue = 100000; // 10^5z

  // Fallback classical RNG for when quantum is unavailable
  final Random _classicalRng = Random();

  Future<void> _generateQuantumRandomNumber() async {
    setState(() {
      _isGenerating = true;
      _randomNumber = null;
    });

    try {
      // Try to get quantum random number from the API
      final response = await http.post(
        Uri.parse('https://qrng-backend.onrender.com/api/generate/hadamard'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(
            {'shots': 32, 'qubits': 5}), // Enough bits for large numbers
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final randomBits = data['random_bits'] as List<dynamic>?;

        if (randomBits != null && randomBits.isNotEmpty) {
          // Convert bits to a large random number
          final bitString = randomBits.take(20).join(''); // Use first 20 bits
          final bigIntValue = BigInt.parse(bitString, radix: 2);

          setState(() {
            _randomNumber = (_minValue +
                    (bigIntValue % BigInt.from(_maxValue - _minValue + 1))
                        .toInt())
                .toInt();
          });
          return;
        }
      }

      // Fallback to classical if quantum fails
      _generateClassicalRandomNumber();
    } catch (e) {
      print('Quantum RNG failed: $e');
      // Fallback to classical RNG
      _generateClassicalRandomNumber();
    } finally {
      setState(() {
        _isGenerating = false;
      });
    }
  }

  void _generateClassicalRandomNumber() {
    final randomValue =
        _minValue + _classicalRng.nextInt(_maxValue - _minValue + 1);
    setState(() {
      _randomNumber = randomValue;
    });
  }

  void _generateRandomNumber() {
    if (_useQuantum) {
      _generateQuantumRandomNumber();
    } else {
      _generateClassicalRandomNumber();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(200, 0, 0, 0),
        appBar: AppBar(
          title: Text(
            'Random Number Generator',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: const Color.fromARGB(141, 0, 0, 0),
          foregroundColor: const Color.fromARGB(255, 255, 255, 255),
        ),
        body: QuantumBackground(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // Header Card
                  Card(
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Colors.deepPurple, Colors.indigo],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.auto_awesome,
                            size: 48,
                            color: Colors.white,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Quantum Random Number',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Generate true random numbers using quantum mechanics',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 24),

                  // Controls Card
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Text(
                            'Configuration',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 20),

                          // Range Controls
                          _buildRangeControl(),
                          SizedBox(height: 20),

                          // RNG Type Toggle
                          _buildRngTypeToggle(),
                          SizedBox(height: 24),

                          // Generate Button
                          Container(
                            width: double.infinity,
                            height: 54,
                            child: ElevatedButton(
                              onPressed:
                                  _isGenerating ? null : _generateRandomNumber,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _useQuantum
                                    ? Colors.deepPurple
                                    : const Color.fromARGB(255, 54, 0, 83),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 4,
                              ),
                              child: _isGenerating
                                  ? SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                      ),
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          _useQuantum
                                              ? Icons.science
                                              : Icons.shuffle,
                                          size: 20,
                                        ),
                                        SizedBox(width: 12),
                                        Text(
                                          _useQuantum
                                              ? 'Generate Quantum Random Number'
                                              : 'Generate Classical Random Number',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 24),

                  // Result Display
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Your Random Number',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 20),
                          if (_randomNumber != null) ...[
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 32, vertical: 24),
                              decoration: BoxDecoration(
                                color: _useQuantum
                                    ? Colors.deepPurple.withOpacity(0.1)
                                    : Colors.blueGrey.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: _useQuantum
                                      ? Colors.deepPurple
                                      : const Color.fromARGB(
                                          255, 255, 255, 255),
                                  width: 2,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    _randomNumber.toString(),
                                    style: TextStyle(
                                      fontSize: 36,
                                      fontWeight: FontWeight.bold,
                                      color: _useQuantum
                                          ? Colors.deepPurple
                                          : const Color.fromARGB(
                                              255, 255, 255, 255),
                                      fontFamily: 'Monospace',
                                    ),
                                  ),
                                  SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        _useQuantum
                                            ? Icons.science
                                            : Icons.shuffle,
                                        size: 16,
                                        color: _useQuantum
                                            ? Colors.deepPurple
                                            : const Color.fromARGB(
                                                255, 255, 255, 255),
                                      ),
                                      SizedBox(width: 6),
                                      Text(
                                        _useQuantum
                                            ? 'Quantum Random'
                                            : 'Classical Random',
                                        style: TextStyle(
                                          color: _useQuantum
                                              ? const Color.fromARGB(
                                                  255, 123, 52, 247)
                                              : const Color.fromARGB(
                                                  255, 255, 255, 255),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20),
                            Text(
                              'Range: $_minValue to $_maxValue',
                              style: TextStyle(
                                color: Colors.grey[600],
                              ),
                            ),
                          ] else ...[
                            Container(
                              padding: EdgeInsets.all(40),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.help_outline,
                                    size: 48,
                                    color: Colors.grey[400],
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    'Press generate to create\na random number',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                      height:
                          20), // Added extra padding at the bottom for better scrolling
                ],
              ),
            ),
          ),
        ));
  }

  Widget _buildRangeControl() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Range',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
        SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Minimum',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 4),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: const Color.fromARGB(255, 178, 91, 255)!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '0',
                      ),
                      onChanged: (value) {
                        final newValue = int.tryParse(value) ?? _minValue;
                        if (newValue >= 0 && newValue < _maxValue) {
                          setState(() {
                            _minValue = newValue;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Maximum',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 4),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: const Color.fromARGB(255, 100, 0, 162)!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '100000',
                      ),
                      onChanged: (value) {
                        final newValue = int.tryParse(value) ?? _maxValue;
                        if (newValue > _minValue && newValue <= 1000000) {
                          setState(() {
                            _maxValue = newValue;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRngTypeToggle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Randomness Source',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
        SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 3, 3, 3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _useQuantum = true),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      color:
                          _useQuantum ? Colors.deepPurple : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.science,
                          size: 16,
                          color: _useQuantum
                              ? Colors.white
                              : const Color.fromARGB(255, 251, 246, 255),
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Quantum',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: _useQuantum
                                ? Colors.white
                                : const Color.fromARGB(255, 247, 234, 255),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _useQuantum = false),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      color: !_useQuantum
                          ? const Color.fromARGB(255, 166, 0, 255)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shuffle,
                          size: 16,
                          color: !_useQuantum
                              ? const Color.fromARGB(255, 255, 255, 255)
                              : const Color.fromARGB(255, 255, 255, 255),
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Classical',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color:
                                !_useQuantum ? Colors.white : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 8),
        Text(
          _useQuantum
              ? 'True randomness from quantum superposition'
              : 'Pseudo-randomness from mathematical algorithms',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}
