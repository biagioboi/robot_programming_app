



import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';



class Connection {
  
  String url='';
  

  Connection(url){
    final _stream;
    this.url=url;
    
  }


  bool connect(){
    final channel = WebSocketChannel.connect(
      Uri.parse('ws://192.168.4.1:81'),
    );  
  print(channel);
  channel.sink.add('Hello!');
    print(channel);
        
    return true;
  }
 
}

