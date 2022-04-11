import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:lb_flutter/tv_list.dart';
import 'package:flutter/services.dart';
import 'package:lb_flutter/lblelinkplugin.dart';
import 'package:lblelinkplugin_example/lb_bloc.dart';
import 'package:collection/collection.dart';

class VideoInfo {
  /// Total length of video
  late double duration;

  /// Current playback progress
  double? currentPosition;

  /// In play
  bool isPlaying = false;

  VideoInfo.fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return;
    }
    this.duration = map["duration"] ?? 0;
    this.currentPosition = map["currentPosition"] ?? 0;
    this.isPlaying = map["isPlaying"];
  }
}

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with LbCallBack {
  String _platformVersion = 'Unknown';

  List<TvData> _serviceNames = [];

  var _key = GlobalKey();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  @override
  void playingCallBack(Object data) {
    print(data);
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    // String platformVersion;
    // // Platform messages may fail, so we use a try/catch PlatformException.
    // // try {
    // //   platformVersion = await Lblelinkplugin.platformVersion;
    // // } on PlatformException {
    // //   platformVersion = 'Failed to get platform version.';
    // // }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    // if (!mounted) return;

    // setState(() {
    //   _platformVersion = platformVersion;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Row(
          children: <Widget>[
            SizedBox(
              width: 100,
              child: Column(
                children: <Widget>[
                  FlatButton(
                      onPressed: () {
                        Lblelinkplugin.initLBSdk(
                            "xxx", "xxx");
                        Lblelinkplugin.eventChannelDistribution();
                      },
                      child: Text("初始化")),
                  FlatButton(
                      onPressed: () {
                        Lblelinkplugin.getServicesList((data) {
                          data.forEach((e) {
                            if (_serviceNames.firstWhereOrNull((e2) =>
                                    e2.ipAddress == e.ipAddress &&
                                    e2.name == e.name) ==
                                null) {
                              _serviceNames.add(e);
                            }
                          });
                          setState(() {});
                        });
                      },
                      child: Text("搜索设备")),
                  FlatButton(
                      onPressed: () {
                        Lblelinkplugin.getLastConnectService().then((value) {
                          print("上次设备是：${value}");
                        });
                      },
                      child: Text("上次设备")),
                  FlatButton(
                      onPressed: () {
                        Lblelinkplugin.play(
                            'http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4');
                      },
                      child: Text("开始投屏")),
                  FlatButton(
                      onPressed: () {
                        Lblelinkplugin.pause();

                        Lblelinkplugin.getLastConnectService().then((data) {
                          print(
                              "******${data.ipAddress},${data.name},${data.uId}");
                        });
                      },
                      child: Text("暂停")),
                  FlatButton(
                      onPressed: () {
                        Lblelinkplugin.resumePlay();
                      },
                      child: Text("继续")),
                  FlatButton(
                      onPressed: () {
                        Lblelinkplugin.stop();
                      },
                      child: Text("结束")),
                  // StreamBuilder<VideoInfo>(
                  //   stream: Lblelinkplugin.progressStream
                  //       .map((event) => VideoInfo.fromMap({
                  //             'currentPosition': event.current,
                  //             'duration': event.duration,
                  //             'isPlaying': event.isPlaying
                  //           })),
                  //   builder: (context, snapshot) {
                  //     var info = snapshot.data;
                  //     if (info == null) {
                  //       return Container(height: 44, color: Colors.red,);
                  //     }
                  //     return TextButton(onPressed: (){}, child: Text(info.currentPosition.toString()));
                  //   },
                  // )
                ],
              ),
            ),
            Expanded(
              child: Container(
                // height: 400,
                color: Colors.lightBlueAccent,
                child: Column(children: [
                  Expanded(
                    child: ListView.separated(
                      itemCount: _serviceNames.length,
                      itemBuilder: (ctx, index) {
                        return GestureDetector(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("设备名称：${_serviceNames[index].name}"),
                              Text(
                                  "ipAddress：${_serviceNames[index].ipAddress}"),
                            ],
                          ),
                          onTap: () {
                            Lblelinkplugin.connectToService(
                                _serviceNames[index].ipAddress,
                                _serviceNames[index].name,
                                fConnectListener: () {},
                                fDisConnectListener: () {});
                          },
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          Container(
                        color: Colors.grey,
                        height: 1,
                      ),
                    ),
                  ),
                  StreamBuilder<VideoInfo>(
                    key: _key,
                    builder: (context, snapshot) {
                      final progress = snapshot.data;
                      if (progress == null ||
                          (progress.duration).isNaN ||
                          (progress.duration).isInfinite) return Container();
                      print('isPlaying ====> ${progress.isPlaying}');
                      return SizedBox(
                        height: 200,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 50,
                              child: LinearProgressIndicator(
                                value: progress.duration > 0 ? ((progress.currentPosition ?? 0) /
                                    (progress.duration)) : 0,
                              ),
                            ),
                            IconButton(
                                icon: Icon(progress.isPlaying
                                    ? Icons.pause
                                    : Icons.play_arrow),
                                onPressed: () {})
                          ],
                        ),
                      );
                    },
                    stream: Lblelinkplugin.progressStream
                        .map((event) => VideoInfo.fromMap({
                              'currentPosition': event.current,
                              'duration': event.duration,
                              'isPlaying': event.isPlaying
                            })),
                  )
                ]),
              ),
            )
          ],
        ),
      ),
    );
  }
}
