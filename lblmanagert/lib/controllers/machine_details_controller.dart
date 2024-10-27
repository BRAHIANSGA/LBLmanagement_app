import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lblmanagert/models/sensor_data.dart';
import 'package:lblmanagert/screens/monitoring/monitoring_page.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'dart:math' as math;
import 'package:lblmanagert/screens/layout/layout.dart';


class MachineDetailsController extends GetxController {
  final machine = Get.arguments as Machine;
  final RxList<SensorData> sensorData = <SensorData>[].obs;
  final zoomPanBehavior = ZoomPanBehavior(
    enablePinching: true,
    enableDoubleTapZooming: true,
    enablePanning: true,
    enableMouseWheelZooming: true,
    zoomMode: ZoomMode.xy,
  );
  
  Timer? _timer;
  final maxPoints = 100;
  final RxBool isRecording = true.obs;
  final RxList<bool> visibleSeries = [true, true, true].obs;

  @override
  void onInit() {
    super.onInit();
    startDataSimulation();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  void toggleRecording() {
    isRecording.toggle();
    if (isRecording.value) {
      startDataSimulation();
    } else {
      _timer?.cancel();
    }
  }

  void toggleSeriesVisibility(int index) {
    visibleSeries[index] = !visibleSeries[index];
    update();
  }

  void startDataSimulation() {
    _timer = Timer.periodic(const Duration(milliseconds: 1000), (timer) {
      if (sensorData.length > maxPoints) {
        sensorData.removeAt(0);
      }
      
      final now = DateTime.now();
      final random = math.Random();
      
      sensorData.add(SensorData(
        now,
        _generateValue(random, 1),
        _generateValue(random, 2),
        _generateValue(random, 3),
      ));
      
      update();
    });
  }

  double _generateValue(math.Random random, int seed) {
    return math.sin(DateTime.now().millisecondsSinceEpoch * 0.001 * seed) * 3 +
           random.nextDouble() * 2 - 1;
  }

  void clearData() {
    sensorData.clear();
    update();
  }
}