import 'package:fan_control/widgets/btn.dart';
import 'package:fan_control/widgets/fan.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _speed = 50;
  bool _isOn = true;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Fan Dashboard')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              height: 140,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.blueAccent.withAlpha(isDark ? 30 : 20),
                borderRadius: BorderRadius.circular(20),
                border: isDark ? null : Border.all(
                  color: Colors.blueAccent.withAlpha(40)
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Fan Speed', style: TextStyle(color: Colors.grey)),
                  Text(
                    '$_speed%',
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const FanImg(40),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return GridView.count(
                    crossAxisCount: 2,
                    childAspectRatio: (constraints.maxWidth / 2) / 160,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    children: [
                      _buildStatCard(
                        'Humidity', '45%', Icons.water_drop, isDark
                      ),
                      _buildStatCard(
                        'Status', _isOn ? '1' : '0', Icons.power, isDark
                      ),
                    ],
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: [
                  AppBtn(
                    '-5',
                    () => setState(() => _speed = (_speed - 5).clamp(0, 100)),
                  ),
                  AppBtn(
                    '+5',
                    () => setState(() => _speed = (_speed + 5).clamp(0, 100)),
                  ),
                  AppBtn(
                    _isOn ? 'OFF' : 'ON',
                    () => setState(() => _isOn = !_isOn),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String val, IconData icon, bool isDark) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: isDark ?
        Colors.white.withAlpha(15) : Colors.grey.withAlpha(25),
        borderRadius: BorderRadius.circular(20),
        border: isDark ?
        null : Border.all(color: Colors.black12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.blueAccent, size: 30),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(color: Colors.grey)),
          Text(
            val,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
