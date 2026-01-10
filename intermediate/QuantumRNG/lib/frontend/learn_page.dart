import 'package:flutter/material.dart';

class LearnPage extends StatelessWidget {
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
                'Learn Quantum Randomness',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              SizedBox(height: 20),
              _buildInfoCard(
                'What is Quantum Randomness?',
                'Quantum randomness arises from fundamental quantum mechanics principles like superposition and entanglement. Unlike classical pseudo-randomness, it\'s truly unpredictable and non-deterministic.',
              ),
              SizedBox(height: 16),
              _buildInfoCard(
                'Hadamard Method',
                'Uses Hadamard gates to put qubits in superposition states. When measured, the qubit collapses to |0⟩ or |1⟩ with equal probability, generating random bits.',
              ),
              SizedBox(height: 16),
              _buildInfoCard(
                'Bell States',
                'Creates entangled pairs of qubits. Measurement outcomes are correlated - if one qubit is |0⟩, the other must be |1⟩, and vice versa. This entanglement provides enhanced randomness.',
              ),
              SizedBox(height: 16),
              _buildInfoCard(
                'GHZ States',
                'Greenberger-Horne-Zeilinger states involve multi-qubit entanglement. All qubits are in a coherent superposition, providing stronger non-local correlations.',
              ),
              SizedBox(height: 16),
              _buildInfoCard(
                'NIST Compliance',
                'Combines multiple quantum sources with post-processing techniques like Von Neumann extraction to remove biases and meet statistical randomness standards.',
              ),
              SizedBox(height: 16),
              _buildInfoCard(
                'Entropy Measurement',
                'Shannon entropy quantifies randomness. Higher entropy (closer to 1 bit per bit) indicates better randomness quality. Quantum methods typically achieve near-perfect entropy.',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String content) {
    return Card(
      elevation: 4,
      color: Colors.white.withOpacity(0.9),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 114, 0, 221),
              ),
            ),
            SizedBox(height: 8),
            Text(
              content,
              style: TextStyle(
                fontSize: 14,
                height: 1.4,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
