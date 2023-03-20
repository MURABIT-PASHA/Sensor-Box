package com.ktun.edu.tr.sensor_box

import io.flutter.embedding.android.FlutterActivity
import androidx.annotation.NonNull
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.content.*
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager


class MainActivity : FlutterActivity() {
    private val sensorChannel = "com.ktun.edu.tr/sensor"
    private lateinit var channel: MethodChannel
    private lateinit var sensorManager: SensorManager


    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, sensorChannel)
        channel.setMethodCallHandler { call, result ->
            when (call.method) {
                "getSensorNames" -> {
                    val sensorNames = getSensorNames()
                    result.success(sensorNames)
                }
                "getSensorValues" -> {
                    val sensorValues = getAllSensorValues()
                    result.success(sensorValues)
                }
                else -> {
                    throw Throwable("Wrong Method Call ")
                }
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
    private fun getAllSensorValues(): Map<String, Map<String, Any>> {
        val sensorManager = getSystemService(Context.SENSOR_SERVICE) as SensorManager
        val deviceSensors: List<Sensor> = sensorManager.getSensorList(Sensor.TYPE_ALL)
        val sensorDataMap = mutableMapOf<String, Map<String, Any>>()

        for (sensor in deviceSensors) {
            println("Sensor name: ")
            print(sensor.name)
            sensorManager.getDefaultSensor(sensor.type)?.also {
                sensorManager.registerListener(
                    object : SensorEventListener {
                    override fun onSensorChanged(event: SensorEvent?) {
                        print("SensorChanged")
                        if (event != null) {
                                val sensorDataEntry = mutableMapOf<String, Any>(
                                    "timestamp" to event.timestamp,
                                    "accuracy" to event.accuracy,
                                    "values" to event.values.toList()
                                )
                                sensorDataMap[sensor.name] = sensorDataEntry
                        }
                    }
                    override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) {
                        return
                    }
                }, it, SensorManager.SENSOR_DELAY_NORMAL, SensorManager.SENSOR_DELAY_NORMAL)
            }
        }
        return sensorDataMap
    }
}
