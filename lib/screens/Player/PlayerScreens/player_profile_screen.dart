import 'package:arcadia/enums/category.dart';
import 'package:arcadia/enums/weapons.dart';
import 'package:arcadia/provider/auth.dart';
import 'package:arcadia/provider/player.dart';
import 'package:arcadia/provider/players.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlayerProfileScreen extends StatefulWidget {
  const PlayerProfileScreen({Key? key}) : super(key: key);

  @override
  _PlayerProfileScreenState createState() => _PlayerProfileScreenState();
}

class _PlayerProfileScreenState extends State<PlayerProfileScreen> {
  bool _isInit = true;
  bool _isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      Provider.of<Players>(context, listen: false)
          .fetchAndSetPlayers()
          .then((value) {
        currPlayer = Provider.of<Players>(context, listen: false).getPlayer(
          Auth.uid!,
        );
        setState(() {
          _isLoading = false;
          // print(currPlayer);
        });
      });
    }
    _isInit = false;
  }

  Player? currPlayer;

  Color getCategoryColor(PlayerCategory cat) {
    switch (cat) {
      case PlayerCategory.gold:
        return Color(0xffd4af37);
      case PlayerCategory.silver:
        return Color(0xffc0c0c0);
      case PlayerCategory.bronze:
        return Color(0xffcd7f32);
      default:
        return Colors.white24;
    }
  }

  String getGunImage(Weapons weapon) {
    return 'assets/guns/${weapon.toString().split('.').last}.png';
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : SafeArea(
          child: SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 280,
                      color: Color(0xff787A91),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 30),
                            child: CircleAvatar(
                              minRadius: 90,
                              backgroundColor:
                                  getCategoryColor(currPlayer!.playerCategory),
                              child: CircleAvatar(
                                minRadius: 80,
                                backgroundColor: Colors.greenAccent,
                                foregroundColor: Colors.white54,
                                child: IconButton(
                                  icon: Icon(Icons.add_a_photo_rounded),
                                  onPressed: () {
                                    //TODO:
                                    // this._getImage();
                                  },
                                ),
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.bottomLeft,
                            padding: const EdgeInsets.only(top: 20, left: 20),
                            child: Text(
                              currPlayer!.name,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color:
                                    getCategoryColor(currPlayer!.playerCategory),
                                fontSize: 35,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Column(
                        children: [
                          Container(
                            width: width * 0.9,
                            height: height * 0.2,
                            decoration: BoxDecoration(
                              color: Color(0xff141E61),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'IGN    :   ${currPlayer!.inGameName}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xffEEEEEE),
                                    fontSize: 20,
                                    // fontWeight: FontWeight.bold
                                  ),
                                ),
                                Text(
                                  'Category   :   ${currPlayer!.playerCategory.toString().split('.').last}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: getCategoryColor(
                                        currPlayer!.playerCategory),
                                    fontSize: 20,
                                    // fontWeight: FontWeight.bold
                                  ),
                                ),
                                Text(
                                  'Hrs Played :   ${currPlayer!.hoursPlayed}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xffEEEEEE),
                                    fontSize: 20,
                                    // fontWeight: FontWeight.bold
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 20),
                            height: height * 0.15,
                            child: Stack(
                              children: [
                                Positioned(
                                  width: width * 0.9,
                                  height: height * 0.1,
                                  top: 20,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Color(0xff5089C6),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 5,
                                  left: -15,
                                  child: Image.asset(
                                    getGunImage(currPlayer!.primaryWeapon),
                                    width: width * 0.6,
                                  ),
                                ),
                                Positioned(
                                  right: 40,
                                  top: 50,
                                  child: Text(
                                    'Primary Weapon',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 20),
                            height: height * 0.15,
                            child: Stack(
                              children: [
                                Positioned(
                                  width: width * 0.9,
                                  height: height * 0.1,
                                  top: 20,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Color(0xff5089C6),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 5,
                                  left: -15,
                                  child: Image.asset(
                                    getGunImage(currPlayer!.secondaryWeapon),
                                    width: width * 0.6,
                                  ),
                                ),
                                Positioned(
                                  right: 30,
                                  top: 50,
                                  child: Text(
                                    'Secondary Weapon',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                
                              ],
                            ),
                          ),
                          ElevatedButton.icon(
                onPressed: () async {
                  await Provider.of<Auth>(context, listen: false).signOut();
                },
                icon: Icon(Icons.arrow_forward),
                label: Text('Sign Out'),
              ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
        );
  }
}