import 'package:flutter/material.dart';
import '../../widgets/navigation_drawer.dart';

class BillingListScreen extends StatelessWidget {
  final List<Map<String, String>> mockBillings = [
    {'patient': 'John Doe', 'amount': '\$200', 'date': '2024-07-10'},
    {'patient': 'Jane Smith', 'amount': '\$150', 'date': '2024-07-11'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Billing List'),
      ),
      drawer: CustomNavigationDrawer(),
      body: Builder(
        builder: (context) => ListView.builder(
          itemCount: mockBillings.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(mockBillings[index]['patient']!),
              subtitle: Text('Amount: ${mockBillings[index]['amount']}'),
              trailing: Text(mockBillings[index]['date']!),
            );
          },
        ),
      ),
    );
  }
}
