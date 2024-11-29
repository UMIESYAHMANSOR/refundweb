import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:refund/component/button.dart';
import 'package:refund/views/add.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Stream<QuerySnapshot> _refundsStream = FirebaseFirestore.instance.collection('refunds').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text('Hello Admin!',
              style: TextStyle(color: Colors.white, fontSize: 20)),
              CurvedGradientButton(
                width: 100,
                height: 30,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddRefundPage()),
                ),
                child: Text('Add New +'),
              ),
              CurvedGradientButton(
                width: 100,
                height: 30,
                onTap: () {
                  Navigator.pop(context);
                },
                child: Text('Logout'),
              ),
            ],
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _refundsStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SizedBox(
                    height: 300,
                    width: 300,
                    child: CircularProgressIndicator());
                }

                final data = snapshot.requireData;

                return SingleChildScrollView(
                  child: DataTable(
                    columns: [
                      DataColumn(label: Text('OrderId' , style: TextStyle(color: Colors.white, fontSize: 18))),
                      DataColumn(label: Text('Details',  style: TextStyle(color: Colors.white, fontSize: 18))),
                      DataColumn(label: Text('Reason',  style: TextStyle(color: Colors.white, fontSize: 18))),
                      DataColumn(label: Text('Total',  style: TextStyle(color: Colors.white, fontSize: 18))),
                      DataColumn(label: Text('Receipt',  style: TextStyle(color: Colors.white, fontSize: 18))),
                    ],
                    rows: data.docs.map((doc) {
                      final order = doc.data() as Map<String, dynamic>;
                      return DataRow(cells: [
                        DataCell(Text(order['orderId'] , style: TextStyle(color: Colors.white, fontSize: 18))),
                        DataCell(Text(order['details'] , style: TextStyle(color: Colors.white, fontSize: 18) )),
                        DataCell(Text(order['reason'] , style: TextStyle(color: Colors.white, fontSize: 18))),
                        DataCell(Text(order['total'] , style: TextStyle(color: Colors.white, fontSize: 18))),
                        DataCell(
                          InkWell(
                            onTap: () => _launchURL(order['receipt']),
                            child: Text(
                              'Download',
                              style: TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                      ]);
                    }).toList(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
