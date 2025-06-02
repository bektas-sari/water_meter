import 'package:flutter/material.dart';

void main() {
  runApp(WaterTrackerApp());
}

class WaterTrackerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daily Water Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            textStyle: TextStyle(inherit: true),
          ),
        ),
      ),
      home: WaterTrackerPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class WaterTrackerPage extends StatefulWidget {
  @override
  _WaterTrackerPageState createState() => _WaterTrackerPageState();
}

class _WaterTrackerPageState extends State<WaterTrackerPage> {
  int dailyLimit = 2000;
  int currentIntake = 0;
  final TextEditingController _waterInputController = TextEditingController();

  void _updateLimit(double value) {
    setState(() {
      dailyLimit = value.toInt();
      if (currentIntake > dailyLimit) {
        currentIntake = dailyLimit;
      }
    });
  }

  void _addWater() {
    int intake = int.tryParse(_waterInputController.text) ?? 0;
    if (intake <= 0) return;

    setState(() {
      if (currentIntake + intake >= dailyLimit) {
        currentIntake = dailyLimit;
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Congratulations!'),
            content: Text('You have reached your daily water goal!'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              ),
            ],
          ),
        );
      } else {
        currentIntake += intake;
      }
      _waterInputController.clear();
    });
  }

  void _reset() {
    setState(() {
      currentIntake = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Daily Water Tracker'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Set Daily Water Limit',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              Slider(
                value: dailyLimit.toDouble(),
                min: 1000,
                max: 5000,
                divisions: 16,
                label: '$dailyLimit ml',
                onChanged: _updateLimit,
              ),
              Text(
                'Daily Limit: $dailyLimit ml',
                style: theme.textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              LinearProgressIndicator(
                value: currentIntake / dailyLimit,
                minHeight: 20,
                backgroundColor: Color(0xffe3f2fd),
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xff64b5f6)),
              ),
              SizedBox(height: 8),
              Text(
                '$currentIntake ml / $dailyLimit ml',
                style: theme.textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24),
              TextField(
                controller: _waterInputController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Enter amount of water (ml)',
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff64b5f6)),
                  ),
                ),
              ),
              SizedBox(height: 12),
              ElevatedButton(
                onPressed: _addWater,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff64b5f6),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text('Add Water'),
              ),
              SizedBox(height: 12),
              ElevatedButton(
                onPressed: _reset,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff90caf9),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text('Reset'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
