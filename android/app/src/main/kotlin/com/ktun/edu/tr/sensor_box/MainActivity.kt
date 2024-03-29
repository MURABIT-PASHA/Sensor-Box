package com.ktun.edu.tr.sensor_box

import android.content.Context
import android.hardware.Sensor
import android.hardware.SensorManager
import android.os.Build
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val methodChannelName: String = "com.ktun.edu.tr/androidMethodChannel"
    private val eventChannelName: String = "com.ktun.edu.tr/androidEventChannel"
    private lateinit var methodChannel: MethodChannel
    private lateinit var eventChannel: EventChannel
    private lateinit var sensorManager: SensorManager
    private fun isWearable(): Boolean {
        return resources.configuration.isScreenRound
    }
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
            sensorManager = getSystemService(Context.SENSOR_SERVICE) as SensorManager
            methodChannel =
                MethodChannel(flutterEngine.dartExecutor.binaryMessenger, methodChannelName)
            eventChannel = EventChannel(
                        flutterEngine.dartExecutor.binaryMessenger, eventChannelName)
            methodChannel.setMethodCallHandler { methodCall, result ->
                when (methodCall.method) {
                    "getSensorsList" -> {
                        result.success(getSensorsList())
                        initSensorEventListener()
                    }
                    "getSensorNamesList" -> {
                        val sensorNames = getSensorNames()
                        result.success(sensorNames)
                    }
                    else -> {
                        result.error("invalid_arguments", "Invalid arguments.", null)
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
    private fun initSensorEventListener(){
        eventChannel.setStreamHandler(
                object :EventChannel.StreamHandler{
                    override fun onCancel(p0: Any?) {}

                    override fun onListen(p0: Any?, p1: EventChannel.EventSink?) {
                        if(p1!=null){
                            sensorManager.getSensorList(Sensor.TYPE_ALL).forEach {
                                sensorManager.registerListener(MySensorListener(p1),it,SensorManager.SENSOR_DELAY_NORMAL)
                            }
                        }
                    }
                }
        )
    }

    private fun extractSensorInfo(sensor: Sensor): Map<String, String>{
        return mapOf(
                "name" to sensor.name,
                "type" to sensor.type.toString(),
                "vendorName" to sensor.vendor.toString(),
                "version" to sensor.version.toString(),
                "resolution" to sensor.resolution.toString(),
                "power" to sensor.power.toString(),
                "maxRange" to sensor.maximumRange.toString(),
                "minDelay" to (sensor.minDelay.toFloat()/1000000.0).toString(),
                "reportingMode" to if(Build.VERSION.SDK_INT>=Build.VERSION_CODES.LOLLIPOP) sensor.reportingMode.toString() else "NA",
                "maxDelay" to if(Build.VERSION.SDK_INT>=Build.VERSION_CODES.LOLLIPOP) (sensor.maxDelay.toFloat()/1000000.0).toString() else "NA",
                "isWakeup" to if(Build.VERSION.SDK_INT>=Build.VERSION_CODES.LOLLIPOP) sensor.isWakeUpSensor.toString() else "NA",
                "isDynamic" to if(Build.VERSION.SDK_INT>=Build.VERSION_CODES.N) sensor.isDynamicSensor.toString() else "NA",
                "highestDirectReportRateValue" to if(Build.VERSION.SDK_INT>=Build.VERSION_CODES.O) sensor.highestDirectReportRateLevel.toString() else "NA",
                "fifoReservedEventCount" to if(Build.VERSION.SDK_INT>=Build.VERSION_CODES.KITKAT) sensor.fifoReservedEventCount.toString() else "NA",
                "fifoMaxEventCount" to if(Build.VERSION.SDK_INT>=Build.VERSION_CODES.KITKAT) sensor.fifoMaxEventCount.toString() else "NA"
        )
    }

    private fun getSensorsList(): Map<String, List<Map<String, String>>>{
        val myMap = mutableMapOf<String, List<Map<String, String>>>()
        listOf(Sensor.TYPE_ACCELEROMETER, Sensor.TYPE_ACCELEROMETER_UNCALIBRATED, Sensor.TYPE_AMBIENT_TEMPERATURE, Sensor.TYPE_GAME_ROTATION_VECTOR, Sensor.TYPE_GEOMAGNETIC_ROTATION_VECTOR, Sensor.TYPE_GRAVITY, Sensor.TYPE_GYROSCOPE, Sensor.TYPE_GYROSCOPE_UNCALIBRATED, Sensor.TYPE_LIGHT, Sensor.TYPE_LINEAR_ACCELERATION, Sensor.TYPE_MAGNETIC_FIELD, Sensor.TYPE_MAGNETIC_FIELD_UNCALIBRATED, Sensor.TYPE_PRESSURE, Sensor.TYPE_PRESSURE, Sensor.TYPE_PROXIMITY, Sensor.TYPE_ROTATION_VECTOR, Sensor.TYPE_RELATIVE_HUMIDITY, Sensor.TYPE_STATIONARY_DETECT, Sensor.TYPE_MOTION_DETECT, Sensor.TYPE_LOW_LATENCY_OFFBODY_DETECT).forEach { elem ->
            val tmp = mutableListOf<Map<String, String>>()
            when(elem){
                Sensor.TYPE_ACCELEROMETER_UNCALIBRATED -> {
                    if (Build.VERSION.SDK_INT>=Build.VERSION_CODES.O){
                        if(sensorManager.getSensorList(elem)!=null){
                            sensorManager.getSensorList(elem).forEach {
                                tmp.add(extractSensorInfo(it))
                            }
                        }
                    }
                }
                Sensor.TYPE_GAME_ROTATION_VECTOR -> {
                    if (Build.VERSION.SDK_INT>=Build.VERSION_CODES.JELLY_BEAN_MR2){
                        if(sensorManager.getSensorList(elem)!=null){
                            sensorManager.getSensorList(elem).forEach {
                                tmp.add(extractSensorInfo(it))
                            }
                        }
                    }
                }
                Sensor.TYPE_GYROSCOPE_UNCALIBRATED -> {
                    if (Build.VERSION.SDK_INT>=Build.VERSION_CODES.JELLY_BEAN_MR2){
                        if(sensorManager.getSensorList(elem)!=null){
                            sensorManager.getSensorList(elem).forEach {
                                tmp.add(extractSensorInfo(it))
                            }
                        }
                    }
                }
                Sensor.TYPE_GEOMAGNETIC_ROTATION_VECTOR -> {
                    if (Build.VERSION.SDK_INT>=Build.VERSION_CODES.KITKAT){
                        if(sensorManager.getSensorList(elem)!=null){
                            sensorManager.getSensorList(elem).forEach {
                                tmp.add(extractSensorInfo(it))
                            }
                        }
                    }
                }
                Sensor.TYPE_MAGNETIC_FIELD_UNCALIBRATED -> {
                    if (Build.VERSION.SDK_INT>=Build.VERSION_CODES.JELLY_BEAN_MR2){
                        if(sensorManager.getSensorList(elem)!=null){
                            sensorManager.getSensorList(elem).forEach {
                                tmp.add(extractSensorInfo(it))
                            }
                        }
                    }
                }
                Sensor.TYPE_LOW_LATENCY_OFFBODY_DETECT -> {
                    if (Build.VERSION.SDK_INT>=Build.VERSION_CODES.O){
                        if(sensorManager.getSensorList(elem)!=null){
                            sensorManager.getSensorList(elem).forEach {
                                tmp.add(extractSensorInfo(it))
                            }
                        }
                    }
                }
                Sensor.TYPE_STATIONARY_DETECT -> {
                    if (Build.VERSION.SDK_INT>=Build.VERSION_CODES.N){
                        if(sensorManager.getSensorList(elem)!=null){
                            sensorManager.getSensorList(elem).forEach {
                                tmp.add(extractSensorInfo(it))
                            }
                        }
                    }
                }
                Sensor.TYPE_MOTION_DETECT -> {
                    if (Build.VERSION.SDK_INT>=Build.VERSION_CODES.N){
                        if(sensorManager.getSensorList(elem)!=null){
                            sensorManager.getSensorList(elem).forEach {
                                tmp.add(extractSensorInfo(it))
                            }
                        }
                    }
                }
                else -> {
                    if(sensorManager.getSensorList(elem)!=null){
                        sensorManager.getSensorList(elem).forEach {
                            tmp.add(extractSensorInfo(it))
                        }
                    }
                }
            }
            myMap[elem.toString()] = tmp
        }
        return myMap
        //initSensorEventListener()
    }
}
