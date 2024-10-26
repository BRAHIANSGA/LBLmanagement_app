import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lblmanagert/screens/layout/layout.dart';

class MonitoringPage extends StatelessWidget {
  const MonitoringPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      title: 'Monitoreo',
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh_rounded),
          onPressed: () {
            // Implementar actualización de datos
          },
        ),
        IconButton(
          icon: const Icon(Icons.filter_list_rounded),
          onPressed: () {
            // Implementar filtros
          },
        ),
      ],
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Resumen de estado
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.blue.shade900,
                    Colors.blue.shade800,
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.shade900.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _buildStatusCard(
                      icon: Icons.check_circle_outline,
                      title: 'Operativas',
                      count: '8',
                      color: Colors.green,
                    ),
                  ),
                  Expanded(
                    child: _buildStatusCard(
                      icon: Icons.warning_amber_rounded,
                      title: 'Advertencias',
                      count: '2',
                      color: Colors.orange,
                    ),
                  ),
                  Expanded(
                    child: _buildStatusCard(
                      icon: Icons.error_outline,
                      title: 'Críticas',
                      count: '1',
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // Título de sección
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Máquinas',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                TextButton.icon(
                  icon: const Icon(Icons.sort),
                  label: const Text('Ordenar'),
                  onPressed: () {
                    // Implementar ordenamiento
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Lista de máquinas
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: dummyMachines.length,
              itemBuilder: (context, index) {
                final machine = dummyMachines[index];
                return _buildMachineCard(machine);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard({
    required IconData icon,
    required String title,
    required String count,
    required Color color,
  }) {
    return Card(
      elevation: 0,
      color: Colors.white.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              count,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withOpacity(0.8),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMachineCard(Machine machine) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Get.toNamed('/machine-details', arguments: machine);
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: machine.getStatusColor().withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      machine.getStatusIcon(),
                      color: machine.getStatusColor(),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          machine.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          machine.location,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildStatusBadge(machine.status),
                ],
              ),
              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildMetric(
                    icon: Icons.speed_rounded,
                    label: 'Eficiencia',
                    value: '${machine.efficiency}%',
                    color: Colors.blue,
                  ),
                  _buildMetric(
                    icon: Icons.power_rounded,
                    label: 'Consumo',
                    value: '${machine.powerConsumption}kW',
                    color: Colors.orange,
                  ),
                  _buildMetric(
                    icon: Icons.timer_rounded,
                    label: 'Tiempo Activo',
                    value: machine.uptime,
                    color: Colors.green,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(MachineStatus status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: status.getColor().withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: status.getColor().withOpacity(0.5),
        ),
      ),
      child: Text(
        status.getName(),
        style: TextStyle(
          color: status.getColor(),
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildMetric({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

// Enums y extensiones para el estado de las máquinas
enum MachineStatus { operational, warning, critical }

extension MachineStatusExtension on MachineStatus {
  String getName() {
    switch (this) {
      case MachineStatus.operational:
        return 'Operativa';
      case MachineStatus.warning:
        return 'Advertencia';
      case MachineStatus.critical:
        return 'Crítica';
    }
  }

  Color getColor() {
    switch (this) {
      case MachineStatus.operational:
        return Colors.green;
      case MachineStatus.warning:
        return Colors.orange;
      case MachineStatus.critical:
        return Colors.red;
    }
  }
}

// Modelo de datos para las máquinas
class Machine {
  final String id;
  final String name;
  final String location;
  final MachineStatus status;
  final int efficiency;
  final double powerConsumption;
  final String uptime;

  Machine({
    required this.id,
    required this.name,
    required this.location,
    required this.status,
    required this.efficiency,
    required this.powerConsumption,
    required this.uptime,
  });

  Color getStatusColor() => status.getColor();

  IconData getStatusIcon() {
    switch (status) {
      case MachineStatus.operational:
        return Icons.check_circle_outline;
      case MachineStatus.warning:
        return Icons.warning_amber_rounded;
      case MachineStatus.critical:
        return Icons.error_outline;
    }
  }
}

// Datos de ejemplo
final List<Machine> dummyMachines = [
  Machine(
    id: '1',
    name: 'Torno CNC-01',
    location: 'Área de Producción A',
    status: MachineStatus.operational,
    efficiency: 95,
    powerConsumption: 7.2,
    uptime: '18h 45m',
  ),
  Machine(
    id: '2',
    name: 'Fresadora FM-02',
    location: 'Área de Producción B',
    status: MachineStatus.warning,
    efficiency: 78,
    powerConsumption: 5.8,
    uptime: '12h 30m',
  ),
  Machine(
    id: '3',
    name: 'Robot Soldador RS-03',
    location: 'Área de Ensamblaje',
    status: MachineStatus.critical,
    efficiency: 45,
    powerConsumption: 9.1,
    uptime: '6h 15m',
  ),
  Machine(
    id: '4',
    name: 'Prensa Hidráulica PH-04',
    location: 'Área de Conformado',
    status: MachineStatus.operational,
    efficiency: 92,
    powerConsumption: 12.3,
    uptime: '22h 10m',
  ),
  // Puedes agregar más máquinas según necesites
];