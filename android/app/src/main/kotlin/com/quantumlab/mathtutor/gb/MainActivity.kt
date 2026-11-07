package com.quantumlab.mathtutor.gb

import android.content.ActivityNotFoundException
import android.content.Intent
import android.content.pm.PackageManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL_NAME,
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "isInstalled" -> result.success(isFootballStudioInstalled())
                "launch" -> {
                    val intent = footballStudioIntent()
                    if (intent == null) {
                        result.error(
                            "launch_failed",
                            "Football Studio has no available launcher activity.",
                            null,
                        )
                    } else {
                        try {
                            startActivity(intent)
                            result.success(true)
                        } catch (error: ActivityNotFoundException) {
                            result.error(
                                "launch_failed",
                                "Football Studio could not be opened.",
                                null,
                            )
                        } catch (error: SecurityException) {
                            result.error(
                                "launch_failed",
                                "Football Studio could not be opened.",
                                null,
                            )
                        }
                    }
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun footballStudioIntent(): Intent? =
        packageManager.getLaunchIntentForPackage(FOOTBALL_STUDIO_PACKAGE)

    private fun isFootballStudioInstalled(): Boolean =
        try {
            packageManager.getPackageInfo(FOOTBALL_STUDIO_PACKAGE, 0)
            true
        } catch (error: PackageManager.NameNotFoundException) {
            false
        }

    private companion object {
        const val CHANNEL_NAME =
            "com.quantumlab.unified_math_tutor/football_studio"
        const val FOOTBALL_STUDIO_PACKAGE = "com.quantumlab.dinopolo"
    }
}
