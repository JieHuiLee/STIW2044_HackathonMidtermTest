import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'model/room.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'mainpage.dart';

class RoomsDetailPage extends StatefulWidget {
  final Rooms room;
  const RoomsDetailPage({Key? key, required this.room}) : super(key: key);
  @override
  State<RoomsDetailPage> createState() => _RoomsDetailPageState();
}

class _RoomsDetailPageState extends State<RoomsDetailPage> {
  List roomMainList = []; //The list detail of the 18 rooms
  String loading = "Loading available room...";
  late double screenHeight, screenWidth, resWidth;
  int scrollcount = 10, rowcount = 2;
  int numRooms = 0;
  final List<int> num = [1, 2, 3];

  @override
  void initState() {
    super.initState();
    _displayDesc();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth <= 600) {
      resWidth = screenWidth;
    } else {
      resWidth = screenWidth * 0.75;
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(134, 166, 167, 1), //#86A6A7
        title: const Text('Room Details',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const MainPage(
                title: 'Rent A Room',
              ),
            ), // add custom icons also
          ),
        ),
      ),
      body: Stack(children: [upperHalf(context), lowerHalf(context)]),
    );
  }

  Widget upperHalf(BuildContext context) {
    return Scaffold(
        body: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
            height: MediaQuery.of(context).size.height * 0.35,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: num.length,
                itemBuilder: (context, index) {
                  return SizedBox(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: Card(
                          color: Colors.blueGrey,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(3, 3, 3, 3),
                            child: CachedNetworkImage(
                              width: screenWidth,
                              fit: BoxFit.cover,
                              imageUrl:
                                  "https://slumberjer.com/rentaroom/images/" +
                                      widget.room.roomid.toString() +
                                      "_" +
                                      num[index].toString() +
                                      ".jpg",
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) =>
                                      LinearProgressIndicator(
                                          value: downloadProgress.progress),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          )));
                })));
  }

  Widget lowerHalf(BuildContext context) {
    return Container(
      height: 600,
      margin: EdgeInsets.only(top: screenHeight / 3),
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: SingleChildScrollView(
          child: Column(
        children: [
          Text("ROOM ID: " + widget.room.roomid.toString()),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 10,
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Table(
                  columnWidths: const {
                    0: FractionColumnWidth(0.4),
                    1: FractionColumnWidth(0.6)
                  },
                  defaultVerticalAlignment: TableCellVerticalAlignment.top,
                  children: [
                    TableRow(children: [
                      const Text('Contact',
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.bold)),
                      Text(widget.room.contact.toString()),
                    ]),
                    TableRow(children: [
                      const Text('Title',
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.bold)),
                      Text(widget.room.title.toString()),
                    ]),
                    TableRow(children: [
                      const Text('Description',
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.bold)),
                      Text(widget.room.description.toString()),
                    ]),
                    TableRow(children: [
                      const Text('Price',
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.bold)),
                      Text("RM " +
                          double.parse(widget.room.price.toString())
                              .toStringAsFixed(2)),
                    ]),
                    TableRow(children: [
                      const Text('Deposit',
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.bold)),
                      Text("RM " +
                          double.parse(widget.room.deposit.toString())
                              .toStringAsFixed(2)),
                    ]),
                    TableRow(children: [
                      const Text('State',
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.bold)),
                      Text(widget.room.state.toString()),
                    ]),
                    TableRow(children: [
                      const Text('Area',
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.bold)),
                      Text(widget.room.area.toString()),
                    ]),
                    TableRow(children: [
                      const Text('Date Created',
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.bold)),
                      Text(widget.room.dateCreated.toString()),
                    ]),
                    TableRow(children: [
                      const Text('Latitude',
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.bold)),
                      Text("RM " +
                          double.parse(widget.room.latitude.toString())
                              .toStringAsFixed(2)),
                    ]),
                    TableRow(children: [
                      const Text('Longitude',
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.bold)),
                      Text("RM " +
                          double.parse(widget.room.longitude.toString())
                              .toStringAsFixed(2)),
                    ]),
                  ],
                ),
              ),
            ),
          ),
        ],
      )),
    );
  }

  Future<void> _displayDesc() async {
    var url = Uri.parse('https://slumberjer.com/rentaroom/php/load_rooms.php');
    http.Response res = await http.get(url);
    var jsonData = res.body;
    var parsedJson = json.decode(jsonData);

    if (res.statusCode == 200) {
      //if successfully request
      print(res.body);
      var extractdata = parsedJson['data'];
      setState(() {
        roomMainList = extractdata['rooms'];
        numRooms = roomMainList.length;
        if (scrollcount >= roomMainList.length) {
          scrollcount = roomMainList.length;
        }
      });
    } else {
      loading = "No Data";
    }
  }
}
