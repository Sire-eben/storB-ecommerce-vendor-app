import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sellers_app/global/global.dart';

class EarningsScreen extends StatefulWidget {
  const EarningsScreen({Key? key}) : super(key: key);

  @override
  State<EarningsScreen> createState() => _EarningsScreenState();
}

class _EarningsScreenState extends State<EarningsScreen> {
  double sellerTotalEarnings = 0;

  retrieveSellerEarnings() async {
    FirebaseFirestore.instance
        .collection("merchants")
        .doc(sharedPreferences!.getString("uid"))
        .get()
        .then((snap) {
      setState(() {
        sellerTotalEarnings = double.parse(snap.data()!["earnings"].toString());
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    retrieveSellerEarnings();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Total Earnings",
              style: TextStyle(
                  letterSpacing: 3, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
              width: 200,
              child: Divider(
                color: Colors.grey,
                thickness: 2,
              ),
            ),
            Text(
              "₦" + sellerTotalEarnings.toString(),
              style: const TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
            ),
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 100, vertical: 40),
              color: Colors.grey.shade100,
              elevation: 2,
              child: ListTile(
                onTap: () {
                  Navigator.pop(context);
                },
                leading: const Icon(
                  Icons.arrow_back,
                  color: Colors.cyan,
                ),
                title: const Text("Back"),
              ),
            )
          ],
        ),
      ),
    ));
  }
}
