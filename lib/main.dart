import 'dart:async';

import 'package:control_pad/control_pad.dart';
import 'package:control_pad/models/gestures.dart';
import 'package:control_pad/models/pad_button_item.dart';
import 'package:control_pad/views/joystick_view.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
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
    // Set landscape orientation
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

class HomePage extends StatefulWidget {
  
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  List<TextSpan> _lista = [TextSpan(text: "prova"), TextSpan(text: "prova2")];
  /*TextSpan _span = TextSpan(
    text: "not connected",
    children:<TextSpan> [,
  );*/

  @override
  Widget build(BuildContext context) {
    
    Color _color = Colors.red;
    double _vel = 0;
    String testo = " Km/h";
    int count=1;
    final _channel = WebSocketChannel.connect(
        Uri.parse('ws://192.168.4.1:81'),
      );
    final stream = _channel.stream;
    connect(){
      setState(() {
         final _channel = WebSocketChannel.connect(
        Uri.parse('ws://192.168.4.1:81'),
      );
      final stream = _channel.stream;
  
      });
   
    }
    
    StreamController<String> stringController = StreamController<String>();
    StreamController<String> colorsController = StreamController<String>();
    colorsController.add("red");
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
              StreamBuilder(
                stream: colorsController.stream,
                builder: ((context, snapshot) {
                  if(snapshot.hasData){
                    if(snapshot.data.toString()=="green"){
                    return  Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.green,
                          border: Border.all(width: 2),
                  ),
                );
                    }
                    
                  }
                  return  Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.red,
                          border: Border.all(width: 2),
                  ),
                ); 
                   
            
                }),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 20,
                width: 100,
                decoration: const BoxDecoration(color: Colors.lightGreen),
               child: Center(
                 child: StreamBuilder(
                   stream: stringController.stream,
                   builder: ((context, snapshot) {
                     if (snapshot.hasData){
                       return 
                       ListView(
                         children: [Text(snapshot.data.toString() + "   Km/h")]);
                     }else{
                       return Text(testo);
                     }
                   })
                 ),
                 
               )
              ),
              Container(
                height: 20,
                width: 100,
                child: Center(child: 
                StreamBuilder(
                   stream: stream,
                   builder: ((context, snapshot) {
                     if (snapshot.connectionState==ConnectionState.active && snapshot.hasData){
                       colorsController.add("green"); 
                       return Text(snapshot.data.toString());
                     }else{
                       return Text("not connected");
                     }
                   })
                 ),),
              )
              
            ],
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
                  stringController.add(distanza.toString()),
                  _channel.sink.add("{\"speed\": " +
                      distanza.toStringAsFixed(2) +
                      ", \"rotation\": " +
                      primo.round().toString() +
                      "}"),
                 
                },
              ),
              SizedBox(width: 100,),
                 JoystickView(
                showArrowsLeftRight: true,
                showArrowsTopBottom: false,
                innerCircleColor: Colors.red,
                onDirectionChanged: (primo, distanza) => {
                  
                  _channel.sink.add("{\"rotation\": " +
                      primo.round().toString() +
                      "}"),
                 
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
