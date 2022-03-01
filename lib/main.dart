import 'package:control_pad/views/joystick_view.dart';
import 'package:flutter/material.dart';

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
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text('Control Pad Example'),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
          children:[ 
            JoystickView(
              showArrowsTopBottom: true,
              showArrowsLeftRight:false ,
              onDirectionChanged: (degrees, distance) {
                if(degrees>=180){
                  print(degrees);
                }
              },
            ),
            
            ],
          ),
          Padding(padding: EdgeInsets.only(left: 10.0,right: 10.0)
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
          children:[ 
            JoystickView(
              showArrowsTopBottom: false,
              showArrowsLeftRight:true ,
              
              onDirectionChanged: (degrees, distance) {
                
              },
              
            ),
              
            ],
          )
        ],
      

      ),
    );
  }
}