import 'dart:convert';

import 'lblelinkplugin.dart';

///
/// @ProjectName:    lblelink_plugin
/// @ClassName:      tv_list
/// @Description:    dart类作用描述
/// @Author:         孙浩
/// @QQ:             243280864
/// @CreateDate:     2020/5/15 15:35

class TvListResult {
  List<TvData> tvList = [];

  void getResultFromMap(data) {
    tvList = [];
    data.forEach((info) {
      tvList.add(TvData()
        ..name = info["tvName"]
        ..uId = info["tvUID"]
        ..ipAddress = info["ipAddress"]);
    });
  }
}

class TvData {
  late String name;
  String? uId;
  late String ipAddress;
}

class ProgressInfo {
  double? current;
  double? duration;
  PlayStatus? playStatus;
  bool?  isPlaying =false;

  Map<String, dynamic>? _map;
  ///Is there any information?
  bool get hasData => _map != null;
  double get progress => (current ?? 0) / (duration ?? 0);
  // ProgressInfo({ this.current,  this.duration,this.playStatus})

  /// Constructing from the native method
  ProgressInfo.fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return;
    }
    this._map = map;
    this.current = (map["current"] as int?)?.toDouble() ?? 0;
    this.duration = (map["duration"] as int?)?.toDouble() ?? 0;
    this.isPlaying = map["isPlaying"];
  }


  @override
  String toString() {
    if (_map == null) {
      return "null";
    }
    return json.encode(_map);
  }

}
