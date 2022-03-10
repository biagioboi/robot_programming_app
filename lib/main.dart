import 'package:control_pad/control_pad.dart';
import 'package:control_pad/models/gestures.dart';
import 'package:control_pad/models/pad_button_item.dart';
import 'package:control_pad/views/joystick_view.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    return MaterialApp(
      title: 'Flutter Demo',
      theme:
          ThemeData(primarySwatch: Colors.blue, backgroundColor: Colors.white),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Gestures> supportedGesture = [
      Gestures.TAPDOWN,
      Gestures.TAPUP,
      Gestures.LONGPRESS,
      Gestures.LONGPRESSUP,
    ];

    final _channel = WebSocketChannel.connect(
      Uri.parse('ws://192.168.4.1:81'),
    );
    connect() {
      final _channel = WebSocketChannel.connect(
        Uri.parse('ws://192.168.4.1:81'),
      );
    }

    List<PadButtonItem> updown = [
      PadButtonItem(
          index: 0,
          buttonText: "",
          pressedColor: Colors.transparent,
          backgroundColor: Colors.transparent),
      PadButtonItem(
          supportedGestures: supportedGesture,
          index: 1,
          buttonText: "B",
          pressedColor: Color.fromARGB(255, 114, 114, 114),
          backgroundColor: Colors.red[100]),
      PadButtonItem(
          index: 2,
          buttonText: "",
          pressedColor: Colors.transparent,
          backgroundColor: Colors.transparent),
      PadButtonItem(
          supportedGestures: supportedGesture,
          index: 3,
          buttonText: "A",
          pressedColor: Color.fromARGB(255, 114, 114, 114),
          backgroundColor: Colors.green[100]),
    ];

    List<PadButtonItem> leftright = [
      PadButtonItem(
          supportedGestures: supportedGesture,
          index: 0,
          buttonText: "C",
          pressedColor: Color.fromARGB(255, 114, 114, 114),
          backgroundColor: Colors.red[100]),
      PadButtonItem(
          index: 1,
          buttonText: "",
          pressedColor: Colors.transparent,
          backgroundColor: Colors.transparent),
      PadButtonItem(
          supportedGestures: supportedGesture,
          index: 2,
          buttonText: "D",
          pressedColor: Color.fromARGB(255, 114, 114, 114),
          backgroundColor: Colors.green[100]),
      PadButtonItem(
          index: 3,
          buttonText: "",
          pressedColor: Colors.transparent,
          backgroundColor: Colors.transparent),
    ];
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Control Pad Example'),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                child: TextButton(
                    onPressed: () => {connect()}, child: Text("Connetti")),
              ),
              SizedBox(
                height: 15,
              ),
              PadButtonsView(
                backgroundPadButtonsColor: Colors.blueGrey,
                buttons: updown,
                buttonsPadding: 15,
                padButtonPressedCallback: (id, gesture) => {},
              )
            ],
          ),
          StreamBuilder(
            initialData: "non connesso",
            stream: _channel.stream,
            builder: (context, snapshot) {
              return Text(snapshot.hasData ? '${snapshot.data}' : '');
            },
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /*PadButtonsView(
                backgroundPadButtonsColor: Colors.blueGrey,
                buttons: leftright,
                buttonsPadding: 15,
              )*/
              JoystickView(
                showArrowsLeftRight: true,
                showArrowsTopBottom: false,
                innerCircleColor: Colors.red,
                onDirectionChanged: (primo, distanza) => {
                  _channel.sink.add("{\"speed\": " +
                      distanza.toStringAsFixed(2) +
                      ", \"rotation\": " +
                      primo.round().toString() +
                      "}"),
                  print(primo)
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
