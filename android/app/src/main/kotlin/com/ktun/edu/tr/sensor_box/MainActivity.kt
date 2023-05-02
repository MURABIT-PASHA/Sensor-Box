package com.ktun.edu.tr.sensor_box

import android.Manifest
import android.bluetooth.BluetoothClass
import android.bluetooth.BluetoothDevice
import android.bluetooth.BluetoothSocket
import android.bluetooth.BluetoothAdapter
import android.content.Context
import android.content.pm.PackageManager
import android.hardware.Sensor
import android.hardware.SensorManager
import android.os.Build
import android.bluetooth.*
import androidx.annotation.NonNull
import androidx.core.app.ActivityCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import java.io.IOException
import java.util.UUID

class MainActivity: FlutterActivity() {
    private val methodChannelName: String = "com.ktun.edu.tr/androidMethodChannel"
    private val eventChannelName: String = "com.ktun.edu.tr/androidEventChannel"
    private lateinit var methodChannel: MethodChannel
    private lateinit var eventChannel: EventChannel
    private lateinit var sensorManager: SensorManager
    private lateinit var bluetoothManager: BluetoothManager
    companion object {
        var myUUID: UUID = UUID.fromString("00001101-0000-1000-8000-00805F9B34FB")

        var bluetoothSocket: BluetoothSocket? = null
        var bluetoothDevice: BluetoothDevice? = null
        var bluetoothAdapter: BluetoothAdapter? = null
        var isConnected: Boolean = false
        lateinit var address: String
    }
    private fun isWearable(): Boolean {
        return resources.configuration.isScreenRound
    }
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
            bluetoothManager = getSystemService(Context.BLUETOOTH_SERVICE) as BluetoothManager
            bluetoothAdapter = bluetoothManager!!.adapter
            sensorManager = getSystemService(Context.SENSOR_SERVICE) as SensorManager
            methodChannel =
                MethodChannel(flutterEngine.dartExecutor.binaryMessenger, methodChannelName)
            methodChannel.setMethodCallHandler { methodCall, result ->
                when (methodCall.method) {
                    "getSensorsList" -> {
                        eventChannel = EventChannel(
                            flutterEngine.dartExecutor.binaryMessenger,
                            eventChannelName
                        )
                        result.success(getSensorsList())
                        initSensorEventListener()
                    }
                    "getSensorNamesList" -> {
                        val sensorNames = getSensorNames()
                        result.success(sensorNames)
                    }
                    "getDevices" -> {
                        result.success(listPairedDevices())
                    }
                    "getStatus" -> {
                        result.success(getStatus())
                    }
                    "getConnect" ->{
                        val deviceAddress = methodCall.argument<String>("deviceAddress")
                        if (deviceAddress != null){
                            MainActivity.address = deviceAddress
                            MainActivity.bluetoothDevice = MainActivity.bluetoothAdapter!!.getRemoteDevice(deviceAddress)
                            if (bluetoothDevice != null){
                                print(deviceAddress)
                                print("\nBaşarılı bir şekilde bağlandı\n")
                                result.success(connectToDevice())
                            }else{
                                print("Bluetooth bağlantısı başarısız oldu")
                            }
                        }else{
                            print("Cihaz adresi iletilmiyor")
                        }
                    }
                    "sendMessage" ->{
                        result.success(sendCommand("startRecord"))
                    }
                    "getMessage" ->{
                        result.success(getCommand())
                    }
                    "closeConnection" ->{
                        result.success(disconnect())
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
    private fun listPairedDevices(): List<Map<String, String>> {
        val pairedDevices = MainActivity.bluetoothAdapter!!.bondedDevices
        val deviceList = mutableListOf<Map<String, String>>()

        if (pairedDevices.isNotEmpty()) {
            for (device in pairedDevices) {
                val deviceClass = device.bluetoothClass.majorDeviceClass
                var deviceType = "Unknown"
                val deviceName = if (ActivityCompat.checkSelfPermission(
                        this,
                        Manifest.permission.BLUETOOTH
                    ) != PackageManager.PERMISSION_GRANTED
                ) {
                    device.name
                } else {
                    ""
                }
                when (deviceClass) {
                    BluetoothClass.Device.Major.AUDIO_VIDEO -> deviceType = "Headset"
                    BluetoothClass.Device.Major.COMPUTER -> deviceType = "Computer"
                    BluetoothClass.Device.Major.PHONE -> deviceType = "Phone"
                    BluetoothClass.Device.Major.WEARABLE -> deviceType = "Wear"
                }
                val deviceMap = mapOf(
                    "name" to deviceName,
                    "address" to device.address,
                    "type" to deviceType
                )
                deviceList.add(deviceMap)
            }
        }

        return deviceList


    }

    private fun connectToDevice(): Boolean {
        try {
            if (ActivityCompat.checkSelfPermission(
                    this,
                    Manifest.permission.BLUETOOTH
                ) != PackageManager.PERMISSION_GRANTED
            ) {
                return false
            }
            MainActivity.bluetoothSocket = bluetoothDevice!!.createInsecureRfcommSocketToServiceRecord(MainActivity.myUUID)
            return if (bluetoothSocket != null){
                if (bluetoothSocket!!.isConnected){
                    true
                }else{
                    bluetoothSocket!!.connect()
                    print("Soket ile başarılı bir bağlantı kuruldu")
                    true
                }
            }else{
                print("Soket ile bağlantı kurulamadı")
                false
            }
        } catch (e: IOException) {
            println("Error: ${e.message}")
            print("Soket ile bağlantı kurulamadı")
            return false
        }
    }

    private fun sendCommand(input: String) {
        if (MainActivity.bluetoothSocket != null) {
            try{
                MainActivity.bluetoothSocket!!.outputStream.write(input.toByteArray())
            } catch(e: IOException) {
                e.printStackTrace()
            }
        }
    }
    private fun getCommand(): String{
        if (MainActivity.bluetoothSocket != null) {
            try{
                val input = MainActivity.bluetoothSocket!!.inputStream
                val result = input.read()
                return result.toString()
            } catch(e: IOException) {
                e.printStackTrace()
            }
        }
        return "null"
    }
    private fun getStatus():Boolean{
        return MainActivity.bluetoothAdapter!!.isEnabled
    }
    private fun disconnect() {
        if (bluetoothSocket != null) {
            try {
                bluetoothSocket!!.close()
                bluetoothSocket = null
                isConnected = false
            } catch (e: IOException) {
                e.printStackTrace()
            }
        }
        finish()
    }
    private fun doInBackground(): String? {
        try {
            if (MainActivity.bluetoothSocket == null || !MainActivity.isConnected) {
                MainActivity.bluetoothAdapter = bluetoothManager.adapter
                val device: BluetoothDevice = MainActivity.bluetoothAdapter!!.getRemoteDevice(
                    MainActivity.address
                )
                if (ActivityCompat.checkSelfPermission(
                        this,
                        Manifest.permission.BLUETOOTH_CONNECT
                    ) != PackageManager.PERMISSION_GRANTED
                ) {

                    return ""
                }
                MainActivity.bluetoothSocket = device.createInsecureRfcommSocketToServiceRecord(MainActivity.myUUID)
                MainActivity.bluetoothAdapter!!.cancelDiscovery()
                MainActivity.bluetoothSocket!!.connect()
            }
        } catch (e: IOException) {
            e.printStackTrace()
        }
        return null
    }
}
