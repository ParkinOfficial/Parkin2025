import 'package:flutter/material.dart';
import 'package:ping_discover_network_forked/ping_discover_network_forked.dart';
import 'package:network_info_plus/network_info_plus.dart';

class CameraDiscoveryPage extends StatefulWidget {
  @override
  _CameraDiscoveryPageState createState() => _CameraDiscoveryPageState();
}

class _CameraDiscoveryPageState extends State<CameraDiscoveryPage> {
  List<String> discoveredDevices = [];

  Future<void> discoverCameras() async {
    final info = NetworkInfo();
    final ip = await info.getWifiIP();

    if (ip == null) return;

    final subnet = ip.substring(0, ip.lastIndexOf('.'));
    const port = 554; // RTSP default port

    final stream = NetworkAnalyzer.discover2(subnet, port, timeout: Duration(milliseconds: 5000));

    await for (final addr in stream) {
      if (addr.exists) {
        print('Found device at: ${addr.ip}');
        setState(() {
          discoveredDevices.add(addr.ip);
        });
      }
    }
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
      body: ListView.builder(
        itemCount: discoveredDevices.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(discoveredDevices[index]),
          );
        },
      ),
    );
  }
}
