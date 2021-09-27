import 'package:arcadia/provider/provider.dart';
import 'package:arcadia/screens/admin/auction_overview.dart';
import 'package:arcadia/screens/player/forms/player_form.dart';
import 'package:arcadia/screens/player/player_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class Wrapper extends StatefulWidget {
  static const routeName = '/wrapper';

  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  bool isAdmin = false;
  bool isData = false;
  bool isLoading = true;

  void initiate() async {
    Auth.setUid();
    var uid = Auth.uid;
    await FirebaseFirestore.instance.collection('Player').doc(uid).get().then(
      (DocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
        if (documentSnapshot.exists) {
          setState(() {
            isData = true;
            isAdmin = documentSnapshot.data()!['isAdmin'];
          });
        }
        setState(() {
          isLoading = false;
        });
      },
    );
  }

  @override
  void initState() {
    super.initState();
    initiate();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else if (isData) {
      return isAdmin ? AdminMainPage() : PlayerDashBoard();
    } else {
      return PlayerForm();
    }
  }
}
