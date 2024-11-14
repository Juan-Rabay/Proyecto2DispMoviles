import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget 
{
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) 
  {
    Future.delayed(const Duration(seconds: 3), () 
    {
      Navigator.pushReplacementNamed(context, '/home');
    });

    return const Scaffold(
      backgroundColor: Colors.brown,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.local_cafe, size: 100, color: Colors.white),
            SizedBox(height: 20),
            Text(
              'Coffee Recipes',
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
