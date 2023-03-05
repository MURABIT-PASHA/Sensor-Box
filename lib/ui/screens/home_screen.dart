import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FlutterBluePlus flutterBlue = FlutterBluePlus.instance;
  List<BluetoothDevice> devicesList = [];
  BluetoothDevice? selectedDevice;
  List<BluetoothService> servicesList = [];

  bool isScanning = false;
  StreamSubscription? scanSubscription;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    scanSubscription?.cancel();
    super.dispose();
  }

  void startScan() {
    setState(() {
      devicesList.clear();
      isScanning = true;
    });

    scanSubscription = flutterBlue.scan(
      timeout: const Duration(seconds: 5),
      withServices: [],
    ).listen((scanResult) {
      print(scanResult.device);
      if (!devicesList.contains(scanResult.device)) {
        setState(() {
          devicesList.add(scanResult.device);
        });
      }
    }, onDone: stopScan);
  }

  void stopScan() {
    scanSubscription?.cancel();
    setState(() {
      isScanning = false;
    });
  }

  Future<void> connectToDevice(BluetoothDevice device) async {
    try {
      await device.connect();
    } catch (e) {
      print(e.toString());
      return;
    }

    discoverServices(device);
  }

  void discoverServices(BluetoothDevice device) async {
    List<BluetoothService> services = await device.discoverServices();
    setState(() {
      servicesList = services;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bluetooth App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: isScanning ? null : startScan,
              child: const Text('Scan for Devices'),
            ),
            const SizedBox(height: 16.0),
            Text('Devices Found:',
                style: Theme.of(context).textTheme.headline6),
            const SizedBox(height: 8.0),
            Expanded(
              child: ListView.builder(
                itemCount: devicesList.length,
                itemBuilder: (BuildContext context, int index) {
                  final device = devicesList[index];
                  return ListTile(
                    title: Text(device.name.isNotEmpty
                        ? device.name
                        : 'Unknown Device'),
                    subtitle: Text(device.id.toString()),
                    onTap: () {
                      stopScan();
                      setState(() {
                        selectedDevice = device;
                      });
                      connectToDevice(device);
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 16.0),
            Text('Selected Device:',
                style: Theme.of(context).textTheme.headline6),
            const SizedBox(height: 8.0),
            selectedDevice != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          'Name: ${selectedDevice!.name.isNotEmpty ? selectedDevice!.name : 'Unknown Device'}'),
                      Text('ID: ${selectedDevice!.id}'),
                      const SizedBox(height: 16.0),
                      Text('Services:',
                          style: Theme.of(context).textTheme.headline6),
                      const SizedBox(height: 8.0),
                      servicesList.isNotEmpty
                          ? Expanded(
                              child: ListView.builder(
                                itemCount: servicesList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final service = servicesList[index];
                                  return ListTile(
                                    title: Text(service.uuid.toString()),
                                  );
                                },
                              ),
                            )
                          : const Text('No Services Found'),
                    ],
                  )
                : const Text('No Device Selected'),
          ],
        ),
      ),
    );
  }
}
