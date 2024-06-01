import 'package:flutter/material.dart';

class  Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("AudioTale", style: Theme.of(context).appBarTheme.titleTextStyle),
        centerTitle: true,
        backgroundColor: const Color(0xff10263C),
        actions: const [Icon(Icons.settings)],
      ),
      body: Center(
        child: Text("Welcome to the HomePage", style: Theme.of(context).textTheme.bodyLarge)
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: ElevatedButton(onPressed: () {}, child: const Text("Add audio")),
    );
  }
}
