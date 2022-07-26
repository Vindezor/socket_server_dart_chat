import 'dart:convert';
import 'dart:io';

import 'package:socket_io/socket_io.dart';

void main(List<String> args) {
  final server = Server();
  final chat = server.of('/chat');

  // server.on("connection", (client){
  //   print("Cliente se ha conectado");

  //   client.on("msg", (data)=>print(data));

  //   client.on("disconnect", (_) => print("cliente desconectado"));
  // });

  List<dynamic> clients = [];
  List<dynamic> clients_name = [];
  chat.on("connection", (client) {
    clients.add(client);
    print("Cliente ${clients.length} conectado");
    client.on("disconnect", (_) {
      print("${clients.length}");
      clients.remove(client);
      print("Cliente removido");
      print("${clients.length}");
    });
    client.on("name", (data) => clients_name.add(data));
    client.on("msg", (data) {
      clients.map((e) {
        if(client != e){
          e.emit("msg", "[${clients_name[clients.indexOf(client)]}] $data");
        }
      }).toList();
    });
  });

  server.listen(3000);
}

Stream<String> readLine() => stdin.transform(utf8.decoder).transform(const LineSplitter());