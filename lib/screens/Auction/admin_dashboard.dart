import 'package:arcadia/constants/app_theme.dart';
import 'package:arcadia/provider/announcement.dart';
import 'package:arcadia/provider/announcements.dart';
import 'package:arcadia/screens/Auction/forms/add_announcement_form.dart';
import 'package:arcadia/screens/Auction/update_announcements.dart';
import 'package:arcadia/screens/Auction/update_matches.dart';
import 'package:arcadia/screens/Auction/update_teams.dart';
import 'package:arcadia/screens/Auction/widgets/admin_announcement_card.dart';
import 'package:arcadia/widgets/announcement_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard>
    with SingleTickerProviderStateMixin {
  // late TabController _tabController;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Admin DashBoard",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
          ),
          bottom: const TabBar(
            indicatorColor: Colors.white70,
            //  controller: _tabController,
            tabs: <Tab>[
              Tab(
                child: Text("Announcements"),
              ),
              Tab(
                child: Text("Matches"),
              ),
              Tab(
                child: Text("Teams"),
              )
            ],
          ),
          centerTitle: true,
        ),
        body: Material(
            color: CustomColors.firebaseNavy,
            child: Container(
                child: TabBarView(
              children: [
                UpdateAnnouncements(),
                UpdateMatches(),
                UpdateTeams(),
              ],
            ))),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blueAccent,
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddAnnouncementForm()),
            );
          },
        ),
      ),
    );
  }
}