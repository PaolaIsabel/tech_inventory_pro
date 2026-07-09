import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: const Text("TechInventory Pro"),
        centerTitle: true,
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {

        },
        icon: const Icon(Icons.add),
        label: const Text("Nuevo Activo"),
      ),

      body: const Center(
        child: Text(
          "No existen activos registrados",
          style: TextStyle(
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}