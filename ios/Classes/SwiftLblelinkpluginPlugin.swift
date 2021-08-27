import Flutter
import UIKit

public class SwiftLblelinkpluginPlugin: NSObject, FlutterPlugin {
    
    
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "lblelinkplugin", binaryMessenger: registrar.messenger())
    let instance = SwiftLblelinkpluginPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
    
    LMLBEventChannelSupport.register(with: registrar);
    
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    
    let dict = call.arguments as? [String:Any]
    
    switch call.method {
        case "initLBSdk":
        LMLBSDKManager.shareInstance.initLBSDK(appid: (dict?["appid"] as? String) ?? "", secretKey: (dict?["secretKey"] as? String) ?? "",result: result);
        break
        case "beginSearchEquipment":
            LMLBSDKManager.shareInstance.beginSearchEquipment()
        break
        case "connectToService":
            LMLBSDKManager.shareInstance.linkToService(ipAddress: dict?["ipAddress"] as? String ?? "");
        break
        case "disConnect":
            LMLBSDKManager.shareInstance.disConnect();
        break
        case "pause":
            LBPlayerManager.shareInstance.pause();
        break
        case "resumePlay":
            LBPlayerManager.shareInstance.resumePlay();
        break
        case "stop":
            LBPlayerManager.shareInstance.stop();
        break
        case "play":
            let mediaType = (dict?["playType"] as? Int) ?? 0
            let startPosition = (dict?["startPosition"] as? Int) ?? 0
            LBPlayerManager.shareInstance.beginPlay(connection: LMLBSDKManager.shareInstance.linkConnection, playUrl: (dict?["playUrlString"] as? String) ?? "", startPosition: startPosition, mediaType: mediaType);
        break
        case "getLastConnectService":
            LMLBSDKManager.shareInstance.getLastConnectService(result: result)
        break
    default:
        result(FlutterMethodNotImplemented)
        break;
    }
    
    //result("iOS " + UIDevice.current.systemVersion)
  }
}
