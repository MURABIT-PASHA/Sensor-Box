package com.ktun.edu.tr.sensor_box

import io.flutter.embedding.android.FlutterActivity
import androidx.annotation.NonNull
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.content.*
import android.content.Intent
import android.hardware.Sensor
import android.hardware.SensorManager
import android.os.Build.VERSION
import android.os.Build.VERSION_CODES
import android.os.Bundle
import android.provider.Settings
import android.util.Log



class MainActivity : FlutterActivity() {
    private val SENSOR_CHANNEL = "com.ktun.edu.tr/sensor"
    private lateinit var channel: MethodChannel
    private lateinit var sensorManager: SensorManager


    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, SENSOR_CHANNEL)
        channel.setMethodCallHandler { call, result ->
            if (call.method == "getSensorNames") {
                val args = call.arguments() as Map<String, String>?
                val sensorNames = getSensorNames()
                result.success(sensorNames)
            }
        }
    }

    private fun getSensorNames(): List<String> {
        sensorManager = getSystemService(Context.SENSOR_SERVICE) as SensorManager
        val deviceSensors: List<Sensor> = sensorManager.getSensorList(Sensor.TYPE_ALL)
        val sensorNames: MutableList<String> = mutableListOf()
        for (sensor in deviceSensors) {
            sensorNames.add(sensor.name)
        }
        return sensorNames
    }
}
