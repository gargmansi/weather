import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather/api.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController city = TextEditingController();
  String cityName = "ferozepur";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xff303644),
        actions: [
          IconButton(
              onPressed: () async {
                await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    backgroundColor: Color(0xff303644),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    content: Container(
                      padding: EdgeInsets.only(left: 10.0),
                      decoration: BoxDecoration(
                          color: Colors.black26,
                          borderRadius: BorderRadius.circular(10.0)),
                      child: TextField(
                        controller: city,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintStyle: TextStyle(color: Colors.white),
                            hintText: "city name"),
                      ),
                    ),
                    actions: [
                      IconButton(
                          onPressed: () {
                            cityName = city.text;
                            city.clear();
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.done,
                            color: Colors.white,
                          ))
                    ],
                  ),
                ).whenComplete(() async {
                  SharedPreferences preferences =
                      await SharedPreferences.getInstance();
                  preferences.setString("city", cityName);
                  setState(() {});
                });
              },
              icon: Icon(Icons.search)),
        ],
      ),
      backgroundColor: Color(0xff303644),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            padding: EdgeInsets.only(top: 20),
            width: MediaQuery.of(context).size.width,
            child: FutureBuilder(
                future: getweather(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: SpinKitThreeBounce(
                        color: Colors.grey,
                        size: 30.0,
                      ),
                    );
                  }
                  var data = snapshot.data as Map<String, dynamic>;
                  if (data["cod"].toString() == "404") {
                    return Center(
                      child: Text(
                        data["message"],
                        style: TextStyle(color: Colors.grey, fontSize: 30.0),
                      ),
                    );
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        data["name"],
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Today",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 22,
                        ),
                      ),
                      SizedBox(
                        height: 0,
                      ),
                      Image.network(
                        "http://openweathermap.org/img/wn/" +
                            data["weather"][0]["icon"] +
                            "@4x.png",

                        // height: 100.0,
                      ),
                      // Icon(
                      //   Icons.cloud_queue_sharp,
                      //   color: Colors.white,
                      //   size: 50,
                      // ),
                      SizedBox(
                        height: 0,
                      ),
                      Text(
                        data["main"]["temp"].toString() + "°",
                        style: TextStyle(color: Colors.white, fontSize: 90),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        data["weather"][0]["description"].toString(),
                        style: TextStyle(color: Colors.grey, fontSize: 20),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Text(
                                "HIGH",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                              Text(
                                data["main"]['temp_max'].toString() + "°",
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 30),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                "LOW",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                              Text(
                                data["main"]['temp_min'].toString() + "°",
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 30),
                              ),
                            ],
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Sunrise",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 18.0),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            DateTime.fromMillisecondsSinceEpoch(
                                  data["sys"]["sunrise"],
                                ).hour.toString() +
                                ":" +
                                DateTime.fromMillisecondsSinceEpoch(
                                        data["sys"]["sunrise"])
                                    .minute
                                    .toString() +
                                "am",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Sunset",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 18.0),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            DateTime.fromMillisecondsSinceEpoch(
                                  data["sys"]["sunset"],
                                ).hour.toString() +
                                ":" +
                                DateTime.fromMillisecondsSinceEpoch(
                                        data["sys"]["sunset"])
                                    .minute
                                    .toString() +
                                "pm",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      )
                    ],
                  );
                }),
          ),
        ),
      ),
    );
  }
}
