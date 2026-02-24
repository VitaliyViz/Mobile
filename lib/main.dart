import 'package:flutter/material.dart';

void main() => runApp(const FanControlApp());

class FanControlApp extends StatefulWidget {
  const FanControlApp({super.key});

  @override
  State<FanControlApp> createState() => _FanControlAppState();
}

class _FanControlAppState extends State<FanControlApp> {
  bool _isDarkTheme = true;

  void toggleTheme() {
    setState(() {
      _isDarkTheme = !_isDarkTheme;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fan Control Lab',
      theme: ThemeData(
        brightness: _isDarkTheme ? Brightness.dark : Brightness.light,
        primaryColor: Colors.blueAccent,
      ),
      home: FanControlScreen(onThemeToggle: toggleTheme),
    );
  }
}

class FanControlScreen extends StatefulWidget {
  const FanControlScreen({
    required this.onThemeToggle,
    super.key,
  });

  final VoidCallback onThemeToggle;

  @override
  State<FanControlScreen> createState() => _FanControlScreenState();
}

class _FanControlScreenState extends State<FanControlScreen> {
  int _fanPower = 0;
  bool _isEmergency = false;
  bool _showNumberEasterEgg = false;
  final TextEditingController _controller = TextEditingController();
  String _message = 'Enter power level (0-100)';

  Color _getPowerColor() {
    if (_isEmergency || _fanPower > 100) return Colors.red;
    if (_fanPower == 0) return Colors.grey;
    if (_fanPower <= 40) return Colors.green;
    if (_fanPower <= 70) return Colors.yellow;
    return Colors.red;
  }

  void _updateSystem(String value) {
    setState(() {
      final String input = value.toLowerCase().trim();

      if (input == 'avada kedavra') {
        _fanPower = 0;
        _isEmergency = true;
        _showNumberEasterEgg = false;
        _message = 'Voldemort decided to turn off the fan...';
      } else if (input == 'theme') {
        widget.onThemeToggle();
        _message = 'Color scheme updated';
      } else if (input == '67.0' || input == '67') {
        _fanPower = 67;
        _isEmergency = false;
        _showNumberEasterEgg = true;
        _message = 'Six Seven!';
      } else {
        final int? parsedValue = int.tryParse(input);
        if (parsedValue != null) {
          _fanPower = parsedValue;
          _isEmergency = _fanPower > 100;
          _showNumberEasterEgg = false;
          _message = _fanPower > 100 
              ? 'WARNING: Limit exceeded!' 
              : 'Power set to: $_fanPower%';
        } else {
          _message = 'Error: Enter a number, "theme", or a spell';
        }
      }
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final Color powerColor = _getPowerColor();

    return Scaffold(
      appBar: AppBar(title: const Text('Smart Fan Control System')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 60),
                if (_showNumberEasterEgg)
                  Text(
                    '67', 
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold, 
                      color: powerColor,
                    ),
                  )
                else if (_isEmergency)
                  Icon(Icons.warning_amber_rounded,
                  size: 100,
                  color: powerColor
                  )
                else
                  Icon(Icons.battery_0_bar, size: 100, color: powerColor),

                const SizedBox(height: 20),
                Text(
                  'Power: $_fanPower%',
                  style: const TextStyle(fontSize: 32,
                  fontWeight: FontWeight.bold
                  ),
                ),
                Text(
                  _message, 
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey, fontSize: 16),
                ),
                const SizedBox(height: 40),
                TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'System Control',
                    hintText: 'Number, "theme" or "Avada Kedavra"',
                  ),
                  onSubmitted: _updateSystem,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => _updateSystem(_controller.text),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: powerColor.withValues(alpha: 0.2),
                    foregroundColor: powerColor,
                  ),
                  child: const Text('Update State'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
