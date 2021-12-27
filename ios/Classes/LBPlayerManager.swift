//
//  LBPlayerManager.swift
//  lblelinkplugin
//
//  Created by yunxiwangluo on 2020/5/14.
//

import UIKit
import LBLelinkKit

class LBPlayerManager: NSObject {
    
    static let shareInstance = LBPlayerManager()
    
    //开始播放
    func beginPlay(connection: LBLelinkConnection, playUrl: String, startPosition: Int = 0, mediaType: Int = 0){
       
       self.player.lelinkConnection = connection;
       
       let playItem = LBLelinkPlayerItem()
        playItem.mediaType = mediaType == 102 ? .videoOnline : .audioOnline;
       playItem.mediaURLString = playUrl
       playItem.startPosition = startPosition;
       self.player.play(with: playItem)
       
   }
    
    func seekTo(seekTime: Int) {
        player.seek(to: seekTime)
    }
    
    //暂停
    func pause(){
        self.player.pause()
    }
    
    //继续播放
    func resumePlay(){
        self.player.resumePlay()
    }
    
    //退出播放
    func stop(){
        self.player.stop()
    }
    
    //增加音量
    func addVolume(){
        self.player.addVolume()
    }
    
    //减小音量
    func reduceVolume(){
        self.player.reduceVolume()
    }
    
    
   // MARK:--------懒加载--------
   //播放器
   lazy var player: LBLelinkPlayer = {
       let a = LBLelinkPlayer()
       a!.delegate = self;
       return a!
   }()

}

extension LBPlayerManager: LBLelinkPlayerDelegate{
    
    //播放状态回调
    func lelinkPlayer(_ player: LBLelinkPlayer!, playStatus: LBLelinkPlayStatus) {
        
        /**
         LBLelinkPlayStatusUnkown = 0,    // 未知状态
         LBLelinkPlayStatusLoading,       // 视频正在加载状态
         LBLelinkPlayStatusPlaying,       // 正在播放状态
         LBLelinkPlayStatusPause,         // 暂停状态
         LBLelinkPlayStatusStopped,       // 退出播放状态
         LBLelinkPlayStatusCommpleted,    // 播放完成状态
         LBLelinkPlayStatusError,         // 播放错误
         */
        
        switch playStatus {
        case .loading:
            LMLBEventChannelSupport.sharedInstance.sendCommonDataToFlutter(type: .load, data: "视频正在加载...")
            break
        case .playing:
        LMLBEventChannelSupport.sharedInstance.sendCommonDataToFlutter(type: .start, data: "开始播放")
        break
        case .pause:
        LMLBEventChannelSupport.sharedInstance.sendCommonDataToFlutter(type: .pause, data: "视频暂停")
        break
        case .stopped:
        LMLBEventChannelSupport.sharedInstance.sendCommonDataToFlutter(type: .stop, data: "退出播放")
        break
        case .commpleted:
        LMLBEventChannelSupport.sharedInstance.sendCommonDataToFlutter(type: .complete, data: "播放完成")
        break
        case .error:
        LMLBEventChannelSupport.sharedInstance.sendCommonDataToFlutter(type: .error, data: "播放出错")
        break
        default:
            break
        }
        
    }
    
    //播放错误回调
    func lelinkPlayer(_ player: LBLelinkPlayer!, onError error: Error!) {
        
        LMLBEventChannelSupport.sharedInstance.sendErrorToFlutter(error: error)
        
    }
    
    //
    func lelinkPlayer(_ player: LBLelinkPlayer!, progressInfo: LBLelinkProgressInfo!) {
        print("当前进度:\(progressInfo.currentTime)");
        LMLBEventChannelSupport.sharedInstance.sendCommonDataToFlutter(type: .position, data: [
            "current": progressInfo.currentTime,
            "duration": progressInfo.duration
        ])
    }
    
}
