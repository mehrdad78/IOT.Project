import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool onOff1 = true;
  bool onOff2 = true;
  bool onOff3 = true;

  final assetsAudioPlayer = AssetsAudioPlayer();
  int time = 10;
  TextEditingController textEditingController = TextEditingController();
  final CountDownController _controller =
      CountDownController(); // connection succeeded

  MqttServerClient client =
      MqttServerClient.withPort('37.32.28.73', 'flutter_client', 1883);

  Future<MqttServerClient> connect() async {
    client.logging(on: true);
    final connMessage = MqttConnectMessage()
        //.authenticateAs('username', 'password')
        .withWillTopic('willtopic')
        .withWillMessage('Will message')
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);
    client.connectionMessage = connMessage;
    try {
      await client.connect();
    } catch (e) {
      log('Exception: $e');
      client.disconnect();
    }

    client.updates?.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final MqttPublishMessage message = c[0].payload as MqttPublishMessage;
      final payload =
          MqttPublishPayload.bytesToStringAsString(message.payload.message);

      log('Received message:$payload from topic: ${c[0].topic}>');
    });

    return client;
  }

  publisher({bool? ttp}) {
    const pubTopic = 'led';
    final builder = MqttClientPayloadBuilder();
    if (ttp == true) {
      builder.addString('1');
    }
    if (ttp == false) {
      builder.addString('0');
    }
    client.publishMessage(pubTopic, MqttQos.atLeastOnce, builder.payload!);
  }

  publisher2({bool? ttp}) {
    const pubTopic = 'led2';
    final builder = MqttClientPayloadBuilder();
    if (ttp == true) {
      builder.addString('1');
    }
    if (ttp == false) {
      builder.addString('0');
    }
    client.publishMessage(pubTopic, MqttQos.atLeastOnce, builder.payload!);
  }

  publisher3({bool? ttp}) {
    const pubTopic = 'led3';
    final builder = MqttClientPayloadBuilder();
    if (ttp == true) {
      builder.addString('1');
    }
    if (ttp == false) {
      builder.addString('0');
    }
    client.publishMessage(pubTopic, MqttQos.atLeastOnce, builder.payload!);
  }

  @override
  void initState() {
    super.initState();
    connect();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: const Text("IOT Project"),
          backgroundColor: Colors.green,
          leading: IconButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showMaterialBanner(MaterialBanner(
                    content:
                        const Text("This Made By Mehrdad.ch for IOT Course"),
                    actions: [
                      IconButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context)
                                .hideCurrentMaterialBanner();
                          },
                          icon: const Icon(Icons.close))
                    ]));
              },
              icon: const Icon(Icons.info_outline))),
      body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
              vertical: height / 16, horizontal: width / 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                  child: Text(
                "Turn Off/On LED1",
                style: TextStyle(
                    fontSize: width / 12, fontWeight: FontWeight.w400),
              )),
              SizedBox(
                height: height / 32,
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: height / 32),
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                    color: Colors.blue.shade100),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 600),
                  padding: EdgeInsets.symmetric(vertical: height / 32),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: onOff1
                        ? Colors.green.withOpacity(0.5)
                        : Colors.green.withOpacity(0.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: GestureDetector(
                    onTap: () {
                      publisher(ttp: onOff1);
                      assetsAudioPlayer.open(
                        Audio("sound/bub.mp3"),
                      );
                      setState(() {
                        onOff1 = !onOff1;
                      });
                    },
                    child: AnimatedContainer(
                      padding: const EdgeInsets.all(15),
                      width: width / 32,
                      duration: const Duration(milliseconds: 800),
                      curve: Curves.easeOut,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: onOff1 ? Colors.green[100] : Colors.yellow),
                      child: onOff1
                          ? Image.asset(
                              "images/lamp.png",
                              width: width / 16,
                              height: height / 8,
                            )
                          : Image.asset(
                              "images/lamp(1).png",
                              width: width / 16,
                              height: height / 8,
                            ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: height / 16),
              Center(
                  child: Text(
                "Timer",
                style: TextStyle(fontSize: width / 8),
              )),
              SizedBox(height: height / 32),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width / 64),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(175, 242, 111, 55),
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  child: TextButton(
                      onPressed: () {
                        Future.delayed(const Duration(milliseconds: 500), () {
                          _controller.start();
                        });
                      },
                      child: const Text(
                        "Tap to Start",
                        style: TextStyle(color: Colors.white),
                      )),
                ),
              ),
              SizedBox(
                height: height / 32,
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: height / 32),
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                    color: Colors.green.shade100),
                child: CircularCountDownTimer(
                  // Countdown duration in Seconds.
                  duration: 10,
                  initialDuration: 0,
                  controller: _controller,
                  // Width of the Countdown Widget.
                  width: MediaQuery.of(context).size.width / 8,
                  // Height of the Countdown Widget.
                  height: MediaQuery.of(context).size.height / 4,
                  // Ring Color for Countdown Widget.
                  ringColor: Colors.grey[300]!,
                  // Ring Gradient for Countdown Widget.
                  ringGradient: null,
                  // Filling Color for Countdown Widget.
                  fillColor: Colors.amberAccent[100]!,
                  // Filling Gradient for Countdown Widget.
                  fillGradient: null,
                  // Background Color for Countdown Widget.
                  backgroundColor: Colors.amber[500],
                  // Background Gradient for Countdown Widget.
                  backgroundGradient: null,
                  // Border Thickness of the Countdown Ring.
                  strokeWidth: 20.0,
                  // Begin and end contours with a flat edge and no extension.
                  strokeCap: StrokeCap.round,
                  // Text Style for Countdown Text.
                  textStyle: const TextStyle(
                      fontSize: 33.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                  // Format for the Countdown Text.
                  textFormat: CountdownTextFormat.S,
                  // Handles Countdown Timer (true for Reverse Countdown (max to 0), false for Forward Countdown (0 to max)).
                  isReverse: true,
                  // Handles Animation Direction (true for Reverse Animation, false for Forward Animation).
                  isReverseAnimation: false,
                  isTimerTextShown: true,
                  autoStart: false,
                  // This Callback will execute when the Countdown Ends.
                  onComplete: () {
                    publisher(ttp: onOff1);
                    setState(() {
                      onOff1 = !onOff1;
                    });
                  },
                ),
              ),
              SizedBox(height: height / 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      for (var i = 0; i < 9; i++) {
                        publisher(ttp: onOff1);
                        publisher2(ttp: onOff2);
                        publisher3(ttp: onOff3);

                          onOff3 = !onOff3;
                          onOff2 = !onOff2;
                          onOff1 = !onOff1;

                        publisher3(ttp: onOff3);
                        publisher2(ttp: onOff2);
                        publisher(ttp: onOff1);
                      }
                        onOff3 = !onOff3;
                          onOff2 = !onOff2;
                          onOff1 = !onOff1;
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: height / 32, horizontal: height / 32),
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          color: Color.fromARGB(161, 246, 46, 46)),
                      child: const Text(
                        "Model 1",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      for (var i = 0; i < 9; i++) {
                        publisher2(ttp: onOff2);

                        setState(() {
                          onOff2 = !onOff2;
                        });
                      }
                      for (var i = 0; i < 9; i++) {
                        publisher3(ttp: onOff3);
                        publisher(ttp: onOff1);
                        setState(() {
                          onOff1 = !onOff1;
                          onOff3 = !onOff3;
                        });
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: height / 32, horizontal: height / 32),
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          color: Color.fromARGB(179, 44, 248, 231)),
                      child: const Text(
                        "Model 2",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      for (var i = 0; i < 9; i++) {
                        publisher3(ttp: onOff3);
                        publisher(ttp: onOff1);
                        setState(() {
                          onOff1 = !onOff1;
                          onOff3 = !onOff3;
                        });
                      }
                      for (var i = 0; i < 9; i++) {
                        publisher2(ttp: onOff2);

                        setState(() {
                          onOff2 = !onOff2;
                        });
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: height / 32, horizontal: height / 32),
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          color: Color.fromARGB(139, 255, 36, 171)),
                      child: const Text(
                        "Model 3",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                ],
              )
            ],
          )),
    );
  }
}
