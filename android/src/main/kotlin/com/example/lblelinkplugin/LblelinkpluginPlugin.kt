package com.example.lblelinkplugin

import android.annotation.SuppressLint
import android.app.Activity
import android.content.Context
import android.util.Log
import androidx.annotation.NonNull;
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** LblelinkpluginPlugin */
public class LblelinkpluginPlugin : FlutterPlugin, ActivityAware, MethodCallHandler {


    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        val channel = MethodChannel(flutterPluginBinding.binaryMessenger, "lblelinkplugin")
        channel.setMethodCallHandler(this)
        EventChannel(
            flutterPluginBinding.binaryMessenger,
            "lblelink_event"
        ).setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                LeBUtil.instance.initEvent(events)
            }

            override fun onCancel(arguments: Any?) {
                LeBUtil.instance.removeEvent()
            }
        })
    }


    companion object {
        @SuppressLint("StaticFieldLeak")
        var activity: Activity? = null

    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "initLBSdk" -> {
                activity?.applicationContext?.run {
                    LeBUtil.instance.initUtil(
                        this,
                        call.argument<String>("appid")!!,
                        call.argument<String>("secretKey")!!,
                        result
                    )
                }
            }
            "connectToService" -> {
                LeBUtil.instance.connectService(
                    call.argument<String>("ipAddress")!!,
                    call.argument<String>("name")!!
                )
            }
            "disConnect" -> {
                LeBUtil.instance.disConnect(result)
            }
            "pause" -> {
                LeBUtil.instance.pause()
            }
            "resumePlay" -> {
                LeBUtil.instance.resumePlay()
            }
            "stop" -> {
                LeBUtil.instance.stop()
            }
            "beginSearchEquipment" -> {
                LeBUtil.instance.searchDevice()
            }
            "stopSearchEquipment" -> {
                LeBUtil.instance.stopSearch()
            }
            "play" -> {
                LeBUtil.instance.play(
                    call.argument<String>("playUrlString")!!,
                    call.argument<Int>("startPosition") ?: 0,
                    call.argument<Int>("playType") ?: 102
                )
            }
            "getLastConnectService" -> {
                LeBUtil.instance.getLastIp(result)
            }
            "seekTo" -> {
                LeBUtil.instance.seekTo(call.argument<Int>("seekTime")?:0)
            }
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
        this.onDetachedFromActivity()
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        this.onAttachedToActivity(binding)
    }

    override fun onDetachedFromActivity() {
        activity = null
    }
}
