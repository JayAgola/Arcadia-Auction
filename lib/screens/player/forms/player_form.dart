import 'dart:io';

import 'package:arcadia/constants/app_theme.dart';
import 'package:arcadia/enums/weapons.dart';
import 'package:arcadia/models/models.dart';
import 'package:arcadia/provider/provider.dart';
import 'package:arcadia/screens/player/player_dashboard.dart';
import 'package:arcadia/screens/onboarding/signin_screen.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class PlayerForm extends StatefulWidget {
  @override
  _PlayerFormState createState() => _PlayerFormState();
}

class _PlayerFormState extends State<PlayerForm> {
  var imageUrl;
  var uid = Auth.uid;
  var _image;
  var imagePicker;
  var type;
  final namecontroller = new TextEditingController();
  final studentIDcontroller = new TextEditingController();
  final iGNcontroller = new TextEditingController();
  final primaryWcontroller = new TextEditingController();
  final secondaryWcontroller = new TextEditingController();
  final streamURLcontroller = new TextEditingController();
  final gameHRScontroller = new TextEditingController();

  Weapons? primaryWeapons = Weapons.AWP;
  Weapons? secondadryWeapons = Weapons.USP;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, 
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Compulsary!!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Please add a images!!'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  uploadImage() async {
    final _firebaseStorage = FirebaseStorage.instance;
    final imagePicker = ImagePicker();
    // PickedFile image;
    //Check Permissions
    await Permission.photos.request();

    var permissionStatus = await Permission.photos.status;

    //if (permissionStatus.isGranted) {
      //Select Image
      // image = (await _imagePicker.getImage(source: ImageSource.gallery))!;
      // var file = File(image.path);
      var image = await imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
      );
      setState(() {
        _image = File(image!.path);
      });
      if (_image != null) {
        //Upload to Firebase
        var snapshot = await _firebaseStorage
            .ref()
            .child('PlayerProfileImages/$uid/image')
            .putFile(_image);
        var downloadUrl = await snapshot.ref.getDownloadURL();
        setState(() {
          imageUrl = downloadUrl;
        });
      } else {
        print('No Image Path Received');
      }
   // }
    //  else {
    //   print('Permission not granted. Try Again with permission access');
    // }
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: 24),
          alignment: Alignment.topCenter,
          color: CustomColors.primaryColor,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 10),
                padding: EdgeInsets.all(20),
                width: double.infinity,
                child: Center(
                  child: Text(
                    "Player Registration",
                    style: TextStyle(color: Colors.yellow, fontSize: 30),
                  ),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Center(
                child: GestureDetector(
                  onTap: () async {
                    await uploadImage();
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(200),
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(color: Colors.grey),
                      child: _image != null
                          ? Image.file(
                              _image,
                              width: 150.0,
                              height: 150.0,
                              fit: BoxFit.fitHeight,
                            )
                          : Container(
                              decoration: BoxDecoration(color: Colors.white70),
                              width: 150,
                              height: 150,
                              child: Icon(
                                Icons.add_a_photo_rounded,
                                color: Colors.grey[800],
                                size: 35,
                              ),
                            ),
                    ),
                  ),
                ),
              ),
              
              SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 32.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: namecontroller,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                          hintText: "Enter Your Name",
                          labelText: "Name",
                          hintStyle: TextStyle(color: Colors.white54),
                          filled: true,
                          fillColor: CustomColors.taskez1,
                          // floatingLabelStyle: TextStyle(color: Colors.yellow),
                          labelStyle: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 14,
                              color: Colors.white70),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                              color: Colors.yellow,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                              color: Colors.blueAccent,
                              width: 2.0,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Cannot be empty";
                          }
                          return null;
                        },
                      
                      ),
                      SizedBox(
                        height: 40.0,
                      ),
                      TextFormField(
                        cursorColor: CustomColors.primaryColor,
                        controller: studentIDcontroller,
                        keyboardType:TextInputType.number ,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                          hintText: " Ex:-20195513",
                          labelText: "Student ID",
                          hintStyle:
                              TextStyle(color: Colors.white54, fontSize: 16),
                          filled: true,
                          fillColor: CustomColors.taskez1,
                          // floatingLabelStyle: TextStyle(color: Colors.yellow),
                          labelStyle: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 14,
                              color: Colors.white70),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                              color: Colors.yellow,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                              color: Colors.blueAccent,
                              width: 2.0,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Cannot be empty";
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 40.0,
                      ),
                      TextFormField(
                        controller: iGNcontroller,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                          hintText: " Ex:- MadMani",
                          labelText: "IGN (In Game Name)",
                          hintStyle: TextStyle(color: Colors.white54),
                          filled: true,
                          fillColor: CustomColors.taskez1,
                          // floatingLabelStyle: TextStyle(color: Colors.yellow),
                          labelStyle: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 14,
                              color: Colors.white70),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                              color: Colors.yellow,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                              color: Colors.blueAccent,
                              width: 2.0,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Cannot be empty";
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 40.0,
                      ),
                      TextFormField(
                        controller: gameHRScontroller,
                        keyboardType: TextInputType.numberWithOptions(),
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Colors.white,
                        ),
                        obscureText: false,
                        decoration: InputDecoration(
                          hintText: "Ex:-1520",
                          labelText: "Game Hours",
                          hintStyle: TextStyle(color: Colors.white54),
                          filled: true,
                          fillColor: CustomColors.taskez1,
                          // floatingLabelStyle: TextStyle(color: Colors.yellow),
                          labelStyle: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 14,
                              color: Colors.white70),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                              color: Colors.yellow,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                              color: Colors.blueAccent,
                              width: 2.0,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Cannot be empty";
                          } else if (value.length < 0) {
                            return "Gaming Hours can not be 0";
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 25.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Primary Weapon",
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.yellow,
                                fontWeight: FontWeight.bold),
                          ),
                          // SizedBox(width: 20,),
                          DropdownButton<Weapons>(
                            // menuMaxHeight: MediaQuery.of(context).size.height,
                            iconEnabledColor: Colors.blueAccent,
                            iconDisabledColor: Colors.blueAccent,
                            dropdownColor: CustomColors.taskez1,
                            underline: Container(
                                // child: Text("Primary Weapons"),
                                color: Colors.transparent),
                            value: primaryWeapons,
                            items: Weapons.values.map((Weapons value) {
                              return DropdownMenuItem<Weapons>(
                                value: value,
                                child: Text(
                                  value.toString().split('.').last,
                                  style: TextStyle(
                                    color: primaryWeapons == value
                                      ? Colors.yellow // Color for selected item
                                      : Colors.white, 
                                      fontSize: 17),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                // print('value is : $value');
                                
                                primaryWeapons = value!;
                                
                              });
                            },
                            // hint: Text(_playerStatus.toString().split('.').last),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Secondary Weapon",
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.yellow,
                                fontWeight: FontWeight.bold),
                          ),
                          DropdownButton<Weapons>(
                            iconEnabledColor: Colors.blueAccent,
                            iconDisabledColor: Colors.blueAccent,
                            dropdownColor: CustomColors.taskez1,
                            underline: Container(color: Colors.transparent),
                            value: secondadryWeapons,
                            // menuMaxHeight:
                            //     MediaQuery.of(context).size.height / 2,
                            items: Weapons.values.map((Weapons value) {
                              return DropdownMenuItem<Weapons>(
                                value: value,
                                child: Text(
                                  value.toString().split('.').last,
                                  style: TextStyle(
                                     color: secondadryWeapons == value
                                      ? Colors.yellow // Color for selected item
                                      : Colors.white, // Color for unselected items
                                
                                      fontSize: 17),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                // print('value is : $value');
                                secondadryWeapons = value!;
                              });
                            },
                            // hint: Text(_playerStatus.toString().split('.').last),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 25.0,
                      ),
                      TextFormField(
                        controller: streamURLcontroller,
                        obscureText: false,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                          hintText:
                              "https://steamcommunity.com/profiles/76561199007256891/",
                          labelText: "Steam URL",
                          hintStyle: TextStyle(color: Colors.white54),
                          filled: true,
                          fillColor: CustomColors.taskez1,
                          // floatingLabelStyle: TextStyle(color: Colors.yellow),
                          labelStyle: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 14,
                              color: Colors.white70),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                              color: Colors.yellow,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                              color: Colors.blueAccent,
                              width: 2.0,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Cannot be empty";
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 60.0,
                      ),
                      GestureDetector(
                          onTap: () {
                            if (imageUrl == null) {
                              _showMyDialog();
                            } else {
                              Provider.of<Players>(context, listen: false)
                                  .addplayerSetup(Player(
                                      studentID: studentIDcontroller.text,
                                      inGameName: iGNcontroller.text,
                                      name: namecontroller.text,
                                      primaryWeapon: Weapons.values.firstWhere(
                                        (e) =>
                                            e.toString() ==
                                            // 'Weapons.' +
                                            primaryWeapons.toString(),
                                      ),
                                      secondaryWeapon:
                                          Weapons.values.firstWhere(
                                        (e) =>
                                            e.toString() ==
                                            // 'Weapons.' +
                                            secondadryWeapons.toString(),
                                      ),
                                      hoursPlayed:
                                          int.parse(gameHRScontroller.text),
                                      steamUrl: streamURLcontroller.text));
                              if (_formKey.currentState!.validate()) {
                                Navigator.pushAndRemoveUntil(context,
                                    MaterialPageRoute(builder: (context) {
                                  return PlayerDashBoard();
                                }), (route) => false);
                              }
                            }
                          },
                          child: AnimatedContainer(
                            duration: Duration(seconds: 1),
                            width: MediaQuery.of(context).size.width / 2,
                            height: 50,
                            alignment: Alignment.center,
                            child: Text(
                              "Register",
                              style: TextStyle(
                                color: CustomColors.taskez1,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            decoration: BoxDecoration(
                              color: Colors.yellow,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          )),
                      SizedBox(height: 20),
                      ElevatedButton(
                      
                        onPressed: () async {
                          await Provider.of<Auth>(context, listen: false)
                              .signOut();
                          Navigator.pushAndRemoveUntil(context,
                              MaterialPageRoute(builder: (context) {
                            return SignInScreen();
                          }), (route) => false);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 73, 82, 96),
                          shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(15))
                           ),
                       
                         child:Padding(
                           padding: const EdgeInsets.all(14.0),
                           child: Text(
                            'Sign Out',
                            style: TextStyle(
                                color: Colors.white, fontWeight: FontWeight.bold),
                                                 ),
                         ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
   
}
