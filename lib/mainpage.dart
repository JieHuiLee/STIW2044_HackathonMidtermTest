import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'model/room.dart';
import 'detail.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List roomMainList = []; //The list detail of the 18 rooms
  String titlecenter = "Loading available room...";
  late double screenHeight, screenWidth, resWidth;
  late ScrollController _scrollController;
  int scrollcount = 10;
  int rowcount = 2;
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _displayDesc();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 600) {
      resWidth = screenWidth;
      rowcount = 2;
    } else {
      resWidth = screenWidth * 0.75;
      rowcount = 3;
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(134, 166, 167, 1), //#86A6A7

        title: Text(widget.title,
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      backgroundColor:
          const Color.fromRGBO(168, 208, 209, 1), //#A8D0D1 (SkyBlue)

      body: roomMainList.isEmpty
          ? Center(
              child: Text(titlecenter,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)))
          : Column(
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
                ),
                const Text("Welcome to Rent A Room"),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: rowcount,
                    controller: _scrollController,
                    children: List.generate(scrollcount, (index) {
                      return Card(
                          shadowColor: Colors.indigo.withOpacity(0.7),
                          child: InkWell(
                            onTap: () => {_roomDetails(index)},
                            child: Column(
                              children: [
                                Flexible(
                                  flex: 6,
                                  child: CachedNetworkImage(
                                    width: screenWidth,
                                    fit: BoxFit.cover,
                                    imageUrl:
                                        "https://slumberjer.com/rentaroom/images/" +
                                            roomMainList[index]["roomid"] +
                                            "_1.jpg",
                                    placeholder: (context, url) =>
                                        const LinearProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                                ),
                                Flexible(
                                    flex: 4,
                                    child: SingleChildScrollView(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Text(
                                              truncateString(roomMainList[index]
                                                      ["title"]
                                                  .toString()),
                                              style: TextStyle(
                                                  fontSize: resWidth * 0.03,
                                                  fontWeight: FontWeight.bold)),
                                          Text(
                                              "Price: RM " +
                                                  double.parse(
                                                          roomMainList[index]
                                                              ['price'])
                                                      .toStringAsFixed(2) +
                                                  "\nDeposit: RM " +
                                                  double.parse(
                                                          roomMainList[index]
                                                              ['deposit'])
                                                      .toStringAsFixed(2),
                                              style: TextStyle(
                                                fontSize: resWidth * 0.03,
                                              )),
                                          Text(
                                              "Area: " +
                                                  truncateString(
                                                          roomMainList[index]
                                                              ['area'])
                                                      .toString(),
                                              style: TextStyle(
                                                fontSize: resWidth * 0.03,
                                              )),
                                        ],
                                      ),
                                    )),
                              ],
                            ),
                          ));
                    }),
                  ),
                ),
              ],
            ),
    );
  }

  Future<void> _displayDesc() async {
    var url = Uri.parse('https://slumberjer.com/rentaroom/php/load_rooms.php');
    http.Response res = await http.get(url);
    if (res.statusCode == 200) {
      //if successfully request
      var jsonData = res.body;
      var parsedJson = json.decode(jsonData);
      roomMainList = parsedJson['data']['rooms'];
      titlecenter = "Data Exists";
      setState(() {});
      print(roomMainList);
    } else {
      titlecenter = "No Data";
      return;
    }
  }

  String truncateString(String str) {
    if (str.length > 15) {
      str = str.substring(0, 15);
      return str + "...";
    } else {
      return str;
    }
  }

  _roomDetails(int index) {
    Rooms room = Rooms(
        roomid: roomMainList[index]['roomid'],
        contact: roomMainList[index]['contact'],
        title: roomMainList[index]['title'],
        description: roomMainList[index]['description'],
        price: roomMainList[index]['price'],
        deposit: roomMainList[index]['deposit'],
        state: roomMainList[index]['state'],
        area: roomMainList[index]['area'],
        dateCreated: roomMainList[index]['dateCreated'],
        latitude: roomMainList[index]['latitude'],
        longitude: roomMainList[index]['longitude']);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => RoomsDetailPage(
                  room: room,
                )));
  }

  _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        if (roomMainList.length > scrollcount) {
          scrollcount = scrollcount + 10;
          if (scrollcount >= roomMainList.length) {
            scrollcount = roomMainList.length;
          }
        }
      });
    }
  }
}
