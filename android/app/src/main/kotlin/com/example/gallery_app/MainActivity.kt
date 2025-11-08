package com.example.gallery_app

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.gallery_app/notifications"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "getNotifications" -> {
                    val list = NotificationStore.getNotifications(applicationContext)
                    result.success(list)
                }
                "clearNotifications" -> {
                    NotificationStore.clear(applicationContext)
                    result.success(true)
                }
                else -> result.notImplemented()
            }
        }
    }
}
