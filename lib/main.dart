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
    
    return MaterialApp(
      title: 'Flutter Demo',
      theme:
          ThemeData(primarySwatch: Colors.blue, backgroundColor: Colors.white),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Color _color = Colors.red;
  double _vel = 0;
  String testo= " Km/h";
  @override
  Widget build(BuildContext context) {
  
    cambiaColor(Color colore){
      setState(() {
        _color=colore;

        
       });
    }
    changeVel(double velocita){
      setState(() {
        _vel = velocita *10;
      });
    }
    var _channel = WebSocketChannel.connect(
      Uri.parse('ws://192.168.4.1:81'),
    );
    var stream = _channel.stream;
    connect() {
      _channel = WebSocketChannel.connect(
        Uri.parse('ws://192.168.4.1:81'),
      );
      stream=_channel.stream;
    }
    _channel.stream.listen(
        (dynamic message) {
          debugPrint('message $message');
        },
        onDone: () {
          debugPrint('ws channel closed');
        },
        onError: (error) {
          debugPrint('ws error $error');
        },
      );
       
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Control Pad Example'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: TextButton(
                  
                    onPressed: () => {connect()}, child: Text("Connetti     ")),
              ),
              Text("Status:  "),
              Container(
                height: 20,
                width: 20,
                
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: _color,
                  border: Border.all(
                    width: 2
                  ),
                ),
              ),
          
            ],
          ),
          Container( 
            height: 20,
            width: 100,
            decoration: BoxDecoration(
              color: Colors.lightGreen
              
            ),
            
            child: Center(
              child:Text(_vel.toString()+testo)
              
            /*  child: StreamBuilder(
                initialData: "0 km/h",
                stream: stream,
                builder: (context, snapshot) {
                  if(snapshot.data=="Connected"){
                    cambiaColor(Colors.green);
                  }
                  return Text(snapshot.hasData ? '${snapshot.data}' : '');
                },
              ),*/
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /*PadButtonsView(
                backgroundPadButtonsColor: Colors.blueGrey,
                buttons: leftright,
                buttonsPadding: 15,
              )*/
              JoystickView(
                showArrowsLeftRight: true,
                showArrowsTopBottom: true,
                innerCircleColor: Colors.amber,
                onDirectionChanged: (primo, distanza) => {
                  _channel.sink.add("{\"speed\": " +
                      distanza.toStringAsFixed(2) +
                      ", \"rotation\": " +
                      primo.round().toString() +
                      "}"),
                  print(primo),
                  changeVel(distanza),
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
