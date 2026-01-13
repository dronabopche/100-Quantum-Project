# 🧠 Single-Qubit Quantum Gates Simulation using Qiskit

This project demonstrates the behavior of **single-qubit quantum gates** using **Qiskit**.  
It focuses on visualizing how different quantum gates transform a qubit state using **quantum circuits** and the **Bloch sphere**.

---

## 📌 Project Overview

The notebook simulates a **single qubit initialized in the |0⟩ state** and applies various quantum gates to observe:

- Statevector evolution
- Circuit representation
- Bloch sphere visualization

This project is intended for:
- Learning quantum computing fundamentals
- Academic lab / practical work
- Beginner-friendly Qiskit demonstrations

---

## 🚀 Gates Implemented

The following single-qubit gates are simulated:

- **Hadamard (H) Gate** – Creates superposition  
- **Pauli-X Gate** – Bit flip  
- **Pauli-Y Gate** – Bit + phase flip  
- **Pauli-Z Gate** – Phase flip  
- **Phase (S) Gate** – π/2 phase rotation  

### Test Cases
1. Gates applied directly on the `|0⟩` state  
2. Gates applied after creating superposition using the Hadamard gate  

---

## 📂 Repository Structure

.
├── single_qubit_qiskit_gates.ipynb
├── README.md

---

## 🛠️ Installation & Setup

### 1️⃣ Clone the Repository
```bash
git clone https://github.com/your-username/single-qubit-qiskit-gates.git
cd single-qubit-qiskit-gates

2️⃣ Install Dependencies

pip install qiskit qiskit-aer matplotlib

3️⃣ Run the Notebook

jupyter notebook

Open single_qubit_qiskit_gates.ipynb and execute the cells sequentially.

⸻

📊 Visualizations Used
	•	Quantum Circuit Diagrams
	•	Bloch Sphere Representation
	•	Statevector Simulation (Ideal Quantum System)

These visualizations help build intuition about how quantum states evolve under different gates.

⸻

🧪 Example Demonstrations
	•	Superposition creation using the Hadamard gate
	•	Phase changes using Pauli-Z and Phase (S) gates
	•	Axis rotations on the Bloch sphere using Pauli-X, Y, and Z gates

⸻

🎯 Learning Outcomes
	•	Understand how single-qubit quantum gates work
	•	Visualize quantum states geometrically
	•	Learn basic Qiskit workflow
	•	Build intuition for phase vs amplitude changes in quantum states

⸻

🔮 Future Improvements
	•	Add T (π/8) gate
	•	Add measurement probability plots
	•	Noise simulation using Qiskit Aer
	•	Extend to multi-qubit systems

⸻

📚 Technologies Used
	•	Python
	•	Qiskit
	•	Qiskit Aer
	•	Matplotlib
	•	Jupyter Notebook

⸻

🤝 Contributing

Contributions and improvements are welcome.
Feel free to fork this repository and submit a pull request.

⸻

📜 License

This project is open-source and intended for educational purposes.

⸻

⭐ Acknowledgements
	•	IBM Qiskit Documentation
	•	Quantum Computing Community
