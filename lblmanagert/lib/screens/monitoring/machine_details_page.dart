import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lblmanagert/controllers/machine_details_controller.dart';
import 'package:lblmanagert/models/sensor_data.dart';
import 'package:lblmanagert/screens/layout/layout.dart';
import 'package:lblmanagert/screens/monitoring/monitoring_page.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MachineDetailsPage extends StatelessWidget {
  MachineDetailsPage({super.key});

  final controller = Get.put(MachineDetailsController());

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      title: controller.machine.name,
      actions: [
        IconButton(
          icon: const Icon(Icons.file_download_outlined),
          onPressed: () {
            // Implementar exportación de datos
          },
        ),
        IconButton(
          icon: const Icon(Icons.settings_outlined),
          onPressed: () {
            // Implementar configuración
          },
        ),
      ],
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatusCard(),
            const SizedBox(height: 24),
            _buildGraphCard(),
            const SizedBox(height: 24),
            _buildMetricsGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              controller.machine.getStatusColor().withOpacity(0.8),
              controller.machine.getStatusColor().withOpacity(0.6),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  controller.machine.getStatusIcon(),
                  color: Colors.white,
                  size: 32,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Estado: ${controller.machine.status.getName()}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        controller.machine.location,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGraphCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Datos del Sensor de Vibración',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                  softWrap:
                      true, // Permite que el texto se ajuste automáticamente
                  overflow: TextOverflow.visible,
                ),
                Row(
                  children: [
                    Obx(() => IconButton(
                          icon: Icon(
                            controller.isRecording.value
                                ? Icons.pause_circle_outline
                                : Icons.play_circle_outline,
                          ),
                          onPressed: controller.toggleRecording,
                        )),
                    IconButton(
                      icon: const Icon(Icons.restart_alt_outlined),
                      onPressed: controller.clearData,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildAxisToggle('Eje X', Colors.red, 0),
                const SizedBox(width: 16),
                _buildAxisToggle('Eje Y', Colors.green, 1),
                const SizedBox(width: 16),
                _buildAxisToggle('Eje Z', Colors.blue, 2),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 400,
              child: GetBuilder<MachineDetailsController>(
                builder: (controller) {
                  return SfCartesianChart(
                    legend: const Legend(
                      isVisible: true,
                      position: LegendPosition.bottom,
                    ),
                    zoomPanBehavior: controller.zoomPanBehavior,
                    primaryXAxis: DateTimeAxis(
                      dateFormat: DateFormat.Hms(),
                      intervalType: DateTimeIntervalType.seconds,
                      autoScrollingDelta: 20,
                      autoScrollingMode: AutoScrollingMode.end,
                    ),
                    primaryYAxis: const NumericAxis(
                      title: AxisTitle(text: 'Amplitud'),
                    ),
                    tooltipBehavior: TooltipBehavior(enable: true),
                    crosshairBehavior: CrosshairBehavior(
                      enable: true,
                      activationMode: ActivationMode.singleTap,
                    ),
                    series: <CartesianSeries<SensorData, DateTime>>[
                      if (controller.visibleSeries[0])
                        FastLineSeries<SensorData, DateTime>(
                          name: 'Eje X',
                          dataSource: controller.sensorData,
                          xValueMapper: (SensorData data, _) => data.time,
                          yValueMapper: (SensorData data, _) => data.x,
                          color: Colors.red,
                        ),
                      if (controller.visibleSeries[1])
                        FastLineSeries<SensorData, DateTime>(
                          name: 'Eje Y',
                          dataSource: controller.sensorData,
                          xValueMapper: (SensorData data, _) => data.time,
                          yValueMapper: (SensorData data, _) => data.y,
                          color: Colors.green,
                        ),
                      if (controller.visibleSeries[2])
                        FastLineSeries<SensorData, DateTime>(
                          name: 'Eje Z',
                          dataSource: controller.sensorData,
                          xValueMapper: (SensorData data, _) => data.time,
                          yValueMapper: (SensorData data, _) => data.z,
                          color: Colors.blue,
                        ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAxisToggle(String axis, Color color, int index) {
    return Obx(() => FilterChip(
          selected: controller.visibleSeries[index],
          label: Text(axis),
          labelStyle: TextStyle(
            color:
                controller.visibleSeries[index] ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
          selectedColor: color,
          checkmarkColor: Colors.white,
          onSelected: (_) => controller.toggleSeriesVisibility(index),
        ));
  }

  Widget _buildMetricsGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1,
      children: [
        _buildMetricCard(
          title: 'Eficiencia',
          value: '${controller.machine.efficiency}%',
          icon: Icons.speed_rounded,
          color: Colors.blue,
        ),
        _buildMetricCard(
          title: 'Consumo Energético',
          value: '${controller.machine.powerConsumption}kW',
          icon: Icons.power_rounded,
          color: Colors.orange,
        ),
        _buildMetricCard(
          title: 'Tiempo Activo',
          value: controller.machine.uptime,
          icon: Icons.timer_rounded,
          color: Colors.green,
        ),
        _buildMetricCard(
          title: 'Temperatura',
          value: '42°C',
          icon: Icons.thermostat_rounded,
          color: Colors.red,
        ),
      ],
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
           
          ],
        ),
      ),
    );
  }
}
