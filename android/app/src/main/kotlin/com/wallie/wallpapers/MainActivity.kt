package com.wallie.wallpapers

import android.app.WallpaperManager
import android.graphics.BitmapFactory
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File

class MainActivity : FlutterActivity() {
    private val channelName = "com.wallie.wallpapers/wallpaper"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName)
            .setMethodCallHandler { call, result ->
                if (call.method == "setWallpaper") {
                    val path = call.argument<String>("path")
                    val location = call.argument<String>("location") ?: "home"
                    if (path == null) {
                        result.success(false)
                        return@setMethodCallHandler
                    }
                    try {
                        val bitmap = BitmapFactory.decodeFile(path)
                        if (bitmap == null) {
                            result.success(false)
                            return@setMethodCallHandler
                        }
                        val wm = WallpaperManager.getInstance(applicationContext)
                        val flags = when (location) {
                            "lock" -> WallpaperManager.FLAG_LOCK
                            "both" -> WallpaperManager.FLAG_SYSTEM or WallpaperManager.FLAG_LOCK
                            else -> WallpaperManager.FLAG_SYSTEM
                        }
                        wm.setBitmap(bitmap, null, true, flags)
                        result.success(true)
                    } catch (e: Exception) {
                        result.success(false)
                    }
                } else {
                    result.notImplemented()
                }
            }
    }
}
