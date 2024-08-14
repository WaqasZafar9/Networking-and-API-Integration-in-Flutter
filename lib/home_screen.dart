import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      appBar: AppBar(
        title: Text('Networking and API Integration'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: FlutterLogo(size: 100),
            ),
            SizedBox(height: 20),
            CustomButton(
              label: 'Fetch users',
              color: Colors.green,
              onTap: () {
                Navigator.pushNamed(context, '/api');
              },
            ),
            CustomButton(
              label: 'Add user',
              color: Colors.blue,
              onTap: () {
                Navigator.pushNamed(context, '/api');
              },
            ),
            CustomButton(
              label: 'Edit user',
              color: Colors.orange,
              onTap: () {
                Navigator.pushNamed(context, '/api');
              },
            ),
            CustomButton(
              label: 'Delete user',
              color: Colors.red,
              onTap: () {
                Navigator.pushNamed(context, '/api');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;

  CustomButton({required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: color, backgroundColor: Colors.white,
          minimumSize: Size(double.infinity, 60),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              label.split(' ')[0],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: color,
              ),
            ),
            Spacer(),
            Text(
              label.split(' ').skip(1).join(' '),
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
