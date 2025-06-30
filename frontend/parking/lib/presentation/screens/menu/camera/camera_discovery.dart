import 'package:flutter/material.dart';
import 'package:ping_discover_network_forked/ping_discover_network_forked.dart';
import 'package:network_info_plus/network_info_plus.dart';

class CameraDiscoveryPage extends StatefulWidget {
  @override
  _CameraDiscoveryPageState createState() => _CameraDiscoveryPageState();
}

class _CameraDiscoveryPageState extends State<CameraDiscoveryPage> {
  List<String> discoveredDevices = [];
  bool isScanning = false;

  Future<void> discoverCameras() async {
    setState(() {
      isScanning = true;
      discoveredDevices.clear();
    });

    final info = NetworkInfo();
    final ip = await info.getWifiIP();

    if (ip == null) {
      setState(() {
        isScanning = false;
      });
      return;
    }

    final subnet = ip.substring(0, ip.lastIndexOf('.'));
    final portsToTry = [80,443];

    for (int port in portsToTry) {
      final stream = NetworkAnalyzer.discover2(subnet, port, timeout: Duration(milliseconds: 300));

      await for (final addr in stream) {
        try {
          if (addr.exists && !discoveredDevices.contains('${addr.ip}:$port')) {
            print('Found device at ${addr.ip} on port $port');
            setState(() {
              discoveredDevices.add('${addr.ip}:$port');
            });
          }
        } catch (e) {

          print('Timeout on ${addr.ip}:$port');
        }
      }
    }

    setState(() {
      isScanning = false;
    });
  }

  @override
  void initState() {
    super.initState();
    discoverCameras();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Camera Discovery")),
      body: Column(
        children: [
          if (isScanning)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            ),
          Expanded(
            child: discoveredDevices.isEmpty
                ? Center(
              child: Text(isScanning
                  ? "Scanning network for cameras..."
                  : "No devices found."),
            )
                : ListView.builder(
              itemCount: discoveredDevices.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Icon(Icons.videocam),
                  title: Text(discoveredDevices[index]),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: discoverCameras,
        child: Icon(Icons.refresh),
      ),
    );
  }
}
