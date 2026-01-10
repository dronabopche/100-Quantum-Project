import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BenchmarkPage extends StatefulWidget {
  @override
  _BenchmarkPageState createState() => _BenchmarkPageState();
}

class _BenchmarkPageState extends State<BenchmarkPage> {
  Map<String, dynamic>? benchmarkResults;
  bool isRunning = false;
  int runs = 100;

  Future<void> runBenchmark() async {
    setState(() {
      isRunning = true;
      benchmarkResults = null;
    });

    try {
      final response = await http.post(
        Uri.parse('https://qrng-backend.onrender.com/api/benchmark'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'runs': runs}),
      );

      if (response.statusCode == 200) {
        setState(() {
          benchmarkResults = jsonDecode(response.body);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        isRunning = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Benchmark Results',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              SizedBox(height: 8),
              Text(
                'Compare performance and randomness quality across all methods',
                style: TextStyle(color: Colors.white70),
              ),
              SizedBox(height: 20),
              Card(
                color: Colors.white.withOpacity(0.9),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text('Number of Runs:',
                              style: TextStyle(color: Colors.black87)),
                          Expanded(
                            child: Slider(
                              value: runs.toDouble(),
                              min: 10,
                              max: 1000,
                              divisions: 99,
                              label: runs.toString(),
                              onChanged: (value) {
                                setState(() {
                                  runs = value.round();
                                });
                              },
                            ),
                          ),
                          Text('$runs',
                              style: TextStyle(color: Colors.black87)),
                        ],
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: isRunning ? null : runBenchmark,
                        child: isRunning
                            ? CircularProgressIndicator()
                            : Text('Run Benchmark'),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              if (benchmarkResults != null) ...[
                // Visualization
                if (benchmarkResults!['visualization'] != null)
                  Card(
                    color: Colors.white.withOpacity(0.9),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            'Benchmark Results Visualization',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 16),
                          Center(
                            child: Image.memory(
                              base64Decode(benchmarkResults!['visualization']
                                  .split(',')[1]),
                              height: 300,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                SizedBox(height: 20),
                // Detailed results
                Card(
                  color: Colors.white.withOpacity(0.9),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Detailed Metrics',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 16),
                        ..._buildMethodMetrics(),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildMethodMetrics() {
    if (benchmarkResults == null) return [];

    List<Widget> widgets = [];
    final results = benchmarkResults!['benchmark_results'];

    results.forEach((method, data) {
      widgets.addAll([
        ListTile(
          title: Text(
            method.toUpperCase(),
            style:
                TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  'Time: ${data['avg_time']?.toStringAsFixed(4)}s ± ${data['std_time']?.toStringAsFixed(4)}s',
                  style: TextStyle(color: Colors.black54)),
              Text(
                  'Entropy: ${data['avg_entropy']?.toStringAsFixed(3)} ± ${data['std_entropy']?.toStringAsFixed(3)}',
                  style: TextStyle(color: Colors.black54)),
            ],
          ),
        ),
        Divider(),
      ]);
    });

    return widgets;
  }
}
