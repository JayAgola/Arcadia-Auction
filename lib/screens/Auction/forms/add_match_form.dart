import 'package:arcadia/provider/match.dart';
import 'package:arcadia/provider/matches.dart';
import 'package:arcadia/provider/team.dart';
import 'package:arcadia/provider/teams.dart';
import 'package:arcadia/screens/Auction/admin_dashboard.dart';
import 'package:arcadia/widgets/blue_box.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:date_format/date_format.dart';
import 'package:intl/intl.dart';

class AddMatchForm extends StatefulWidget {
  const AddMatchForm({Key? key}) : super(key: key);

  @override
  _AddMatchFormState createState() => _AddMatchFormState();
}

class _AddMatchFormState extends State<AddMatchForm> {
  List<Team> teams = [];
  String _team1 = "";
  String _team2 = "";

  late String _setTime, _setDate;
  late String _hour, _minute, _time;
  late String dateTime;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);
  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();

  void didChangeDependencies() {
    super.didChangeDependencies();
    Provider.of<Teams>(context, listen: false).fetchAndSetTeams();
  }

  @override
  void initState() {
    super.initState();
    _team1 = '0';
    _team2 = '1';
    _dateController.text = DateFormat.yMd().format(DateTime.now());

    _timeController.text = formatDate(
        DateTime(2019, 08, 1, DateTime.now().hour, DateTime.now().minute),
        [hh, ':', nn, " ", am]).toString();
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null)
      setState(() {
        selectedDate = picked;
        _dateController.text = DateFormat("yyyy-MM-dd").format(selectedDate);
      });
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null)
      setState(() {
        selectedTime = picked;
        _hour = selectedTime.hour.toString();
        _minute = selectedTime.minute.toString();
        _time = _hour + ' : ' + _minute;
        _timeController.text = _time;
        _timeController.text = formatDate(
            DateTime(selectedTime.hour, selectedTime.minute),
            [hh, ':', nn, "", am]).toString();
      });
  }

  String readTimestamp(int timestamp) {
    var now = new DateTime.now();
    var format = new DateFormat('HH:mm a');
    var date = new DateTime.fromMicrosecondsSinceEpoch(timestamp * 1000);
    var diff = date.difference(now);
    var time = '';

    if (diff.inSeconds <= 0 ||
        diff.inSeconds > 0 && diff.inMinutes == 0 ||
        diff.inMinutes > 0 && diff.inHours == 0 ||
        diff.inHours > 0 && diff.inDays == 0) {
      time = format.format(date);
    } else {
      if (diff.inDays == 1) {
        time = diff.inDays.toString() + 'DAY AGO';
      } else {
        time = diff.inDays.toString() + 'DAYS AGO';
      }
    }

    return time;
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    dateTime = DateFormat.yMd().format(DateTime.now());
    teams = Provider.of<Teams>(context, listen: false).teams;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add Match",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: 24),
          alignment: Alignment.topCenter,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          child: Column(
            children: [
              SizedBox(
                height: 12,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 32.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: DropdownButton<String>(
                          value: _team1,
                          onChanged: (newVal) {
                            setState(() {
                              _team1 = newVal!;
                            });
                          },
                          items: [
                            ...teams
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e.teamUid.toString(),
                                    child: Text('${e.teamName}'),
                                  ),
                                )
                                .toList(),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Vs",
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: DropdownButton<String>(
                          value: _team2,
                          onChanged: (newVal) {
                            setState(() {
                              _team2 = newVal!;
                            });
                          },
                          items: [
                            ...teams
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e.teamUid.toString(),
                                    child: Text('${e.teamName}'),
                                  ),
                                )
                                .toList(),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Choose Date',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          _selectDate(context);
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width / 2,
                          height: MediaQuery.of(context).size.height / 15,
                          margin: EdgeInsets.only(top: 30),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(color: Colors.grey[200]),
                          child: TextFormField(
                            style: TextStyle(fontSize: 25),
                            textAlign: TextAlign.center,
                            enabled: false,
                            keyboardType: TextInputType.text,
                            controller: _dateController,

                            //////
                            onSaved: (String? val) {
                              _setDate = val!;
                            },
                            /////

                            decoration: InputDecoration(
                                disabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide.none),
                                // labelText: 'Time',
                                contentPadding: EdgeInsets.only(top: 0.0)),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Choose Time',
                        style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5),
                      ),
                      InkWell(
                        onTap: () {
                          _selectTime(context);
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 30),
                          width: MediaQuery.of(context).size.width / 2,
                          height: MediaQuery.of(context).size.height / 15,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(color: Colors.grey[200]),
                          child: TextFormField(
                            style: TextStyle(fontSize: 25),
                            textAlign: TextAlign.center,
                            onSaved: (String? val) {
                              _setTime = val!;
                            },
                            enabled: false,
                            keyboardType: TextInputType.text,
                            controller: _timeController,
                            decoration: InputDecoration(
                                disabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide.none),
                                // labelText: 'Time',
                                contentPadding: EdgeInsets.all(5)),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      GestureDetector(
                        child: blueButton(
                            context: context,
                            label: "Save",
                            buttonWidth: MediaQuery.of(context).size.width / 2),
                        onTap: () {
                          int id = Provider.of<Matches>(context, listen: false)
                              .matches
                              .length;
                          Map<String, int> points = {};
                          Map<String, int> roundswon = {};
                          // print(_dateController.text);
                          // print(_timeController.text);
                          // print(selectedDate);
                          // print(selectedTime);

                          final now = selectedDate;
                          DateTime datetime = DateTime(now.year, now.month,
                              now.day, selectedTime.hour, selectedTime.minute);

                          Provider.of<Matches>(context, listen: false)
                              .addMatches(
                            Match(
                                matchId: id.toString(),
                                isCompleted: false,
                                teamId1: _team1,
                                teamId2: _team2,
                                matchTime: datetime,
                                mvpId: "",
                                points: points,
                                roundDiff: 0,
                                roundsWon: roundswon),
                          );
                          if (_formKey.currentState!.validate()) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AdminDashboard()));
                          }
                        },
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