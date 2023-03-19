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
            if (call.method == "getSensorNames") {
                val sensorNames = getSensorNames()
                result.success(sensorNames)
            }
            else if (call.method == "getSensorValues"){
                val sensorValues = getAllSensorValues()
                result.success(sensorValues)
            }
            else{
                throw Throwable("Wrong Method Call ")
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
    private fun getAllSensorValues(): List<SensorData> {
        val sensorManager = getSystemService(Context.SENSOR_SERVICE) as SensorManager
        val deviceSensors: List<Sensor> = sensorManager.getSensorList(Sensor.TYPE_ALL)
        val sensorDataList = mutableListOf<SensorData>()
        for (sensor in deviceSensors) {
            sensorManager.registerListener(object : SensorEventListener {
                override fun onSensorChanged(event: SensorEvent?) {
                    if (event != null) {
                        val sensorData = SensorData(
                            sensorName = sensor.name,
                            timestamp = event.timestamp,
                            accuracy = event.accuracy,
                            x = event.values[0],
                            y = event.values[1],
                            z = event.values[2]
                        )
                        sensorDataList.add(sensorData)
                    }
                }
                override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) {
                    // ignore
                }
            }, sensor, SensorManager.SENSOR_DELAY_NORMAL)
        }
        return sensorDataList
    }
    data class SensorData(
        val sensorName: String,
        val timestamp: Long,
        val accuracy: Int,
        val x: Float,
        val y: Float,
        val z: Float
    )
}
