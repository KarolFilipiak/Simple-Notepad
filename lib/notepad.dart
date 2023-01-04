import 'dart:async';

import 'package:flutter/material.dart' hide Intent;
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'settings.dart';
import 'package:receive_intent/receive_intent.dart';

class Notepad extends StatefulWidget {
  const Notepad({Key? key}) : super(key: key);

  @override
  State<Notepad> createState() => _NotepadState();
}

class _NotepadState extends State<Notepad> {
  static const platform = MethodChannel('app.channel.shared.data');
  final _storage = const FlutterSecureStorage();
  String _data = "";
  final _dataFieldController = TextEditingController();
  bool _isLoading = true;
  bool _addButton = false;
  Intent _initialIntent = Intent();

  void _display () async {
    if (await _storage.containsKey(key: "data") && await _storage.read(key: "data") != null)
    {
      setState(() {
        _addButton = true;
      });
    }
    else
    {
      setState(() {
        _addButton = false;
      });
    }
  }

  Widget _optionalButton()
  {
    if (_addButton)
    {
      return Row(
        children: [
          SizedBox(
            width: 0.01 * MediaQuery.of(context).size.width,
          ),
          ElevatedButton(
            onPressed: () {
              _readData();
            },
            style: ElevatedButton.styleFrom(
              primary: color_button,
            ),
            child: Row(
              children: [
                Icon(Icons.question_mark)
              ]
            )
          )
        ],
      );
    }
    else
    {
      return SizedBox(width: 0, height: 0,);
    }
  }

  void _save() async {
    _storage.write(key: "note", value: _data);

  }

  void _saveToData(String? input) async {
    if (input != null && input !="null") {
      _storage.write(key: "data", value: input);
      setState(() {
        /* _data = sharedData;
        _dataFieldController.text = sharedData; */
      });
      SystemNavigator.pop();
    }

  }

  void _read() async {
    setState(() {
      _isLoading = true;
    });
    if (await _storage.containsKey(key: "note") && await _storage.read(key: "note") != null)
    {
      _data = (await _storage.read(key: "note"))!;
    }
    else
    {
      _data = "";
    }
    setState(() {
      _dataFieldController.text = _data;
      _isLoading = false;
    });
  }

  void _readData() async {
    setState(() {
      _isLoading = true;
    });
    if (await _storage.containsKey(key: "data") && await _storage.read(key: "data") != null)
    {
      _data = (await _storage.read(key: "data"))!;
    }
    else
    {
      _data = "";
    }
    setState(() {
      _dataFieldController.text = _data;
      _isLoading = false;
    });
  }

  void _clear() async {
    setState(() {
      _data = "";
      _dataFieldController.text = "";
    });
  }

  void _delete() async {
    _storage.delete(key: "note");
    _storage.delete(key: "data");
    _clear();
    snack(Overlay.of(context), "Note deleted form storage", color_notification_negative);
  }

  @override
  void initState() {
    _read();
    super.initState();
    _initReceiveIntent();
    
  }

  Future<void> _initReceiveIntent() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      final receivedIntent = await ReceiveIntent.getInitialIntent();
      
      if (receivedIntent != null)
      {
        _saveToData(receivedIntent.data.toString());
      }
      else
      {
        _saveToData("input");
      }
      // Validate receivedIntent and warn the user, if it is not correct,
      // but keep in mind it could be `null` or "empty"(`receivedIntent.isNull`).
    } on PlatformException {
      print("wrong platform");
    }
  }

  /* late StreamSubscription _sub;
  
  Future<void> _initReceiveIntentit() async {
    // ... check initialIntent

    // Attach a listener to the stream
    _sub = ReceiveIntent.receivedIntentStream.listen((Intent? intent) {
      // Validate receivedIntent and warn the user, if it is not correct,
      
    }, onError: (err) {
      // Handle exception
    });

  }

  @override
  void dispose(){
    super.dispose();
    _sub.cancel();
  } */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: color_appbar,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Welcome!",
              style: TextStyle(
                fontWeight: FontWeight.values[4],
                color: color_text_appbar
              ),
            ),
          ],
        ),
      ),
      backgroundColor: color_background,
      body: Container(
        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * margin_vertical, bottom: MediaQuery.of(context).size.height * margin_vertical, left: MediaQuery.of(context).size.width * margin_horizontal, right: MediaQuery.of(context).size.width * margin_horizontal),
        child: ListView(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 3 * interline_padding),
                    child: Text(
                      "Welcome to simple notepad!",
                      style: TextStyle(
                        fontWeight: FontWeight.values[6],
                        color: color_text_info
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * (1 - (2 * margin_horizontal)),
                    height: MediaQuery.of(context).size.height * 0.7 * (1 - (2 * margin_vertical)),
                    child: TextField(
                      onChanged: (var value) {
                        setState(() {
                          _data = value;
                        });
                      },
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: "Your notes will appear here",
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(
                            left: 8, right: 8, bottom: 8
                          )
                      ),
                      controller: _dataFieldController,
                      maxLines: null,
                      expands: true,
                    ),
                  ),
                  SizedBox(
                    height: 2 * interline_padding,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          _save();
                          snack(Overlay.of(context), "Note saved successfuly", color_notification_positive);
                        },
                        style: ElevatedButton.styleFrom(

                          primary: color_button,
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.save)
                          ]
                        )
                      ),
                      SizedBox(
                        width: 0.01 * MediaQuery.of(context).size.width,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _display();
                          _read();
                        },
                        style: ElevatedButton.styleFrom(

                          primary: color_button,
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.restore)
                          ]
                        )
                      ),
                      SizedBox(
                        width: 0.01 * MediaQuery.of(context).size.width,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _clear();
                          _display();
                        },
                        style: ElevatedButton.styleFrom(

                          primary: color_button,
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.clear)
                          ]
                        )
                      ),
                      SizedBox(
                        width: 0.01 * MediaQuery.of(context).size.width,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _delete();
                        },
                        style: ElevatedButton.styleFrom(

                          primary: color_button,
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.delete_forever)
                          ]
                        )
                      ),
                      _optionalButton()
                    ],
                  )
                ],
            )
            )
          ],
        )
      ),
    );
  }
}