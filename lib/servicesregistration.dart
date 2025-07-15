import 'package:flutter/material.dart';
import 'Confirm.dart';

class ServicesRegistrationPage extends StatefulWidget {
  @override
  _ServicesRegistrationPageState createState() => _ServicesRegistrationPageState();
}

class _ServicesRegistrationPageState extends State<ServicesRegistrationPage> {
  // Example service data
  final List<Map<String, dynamic>> services = [
    {
      'title': 'Skin Analysis',
      'description': 'Comprehensive skin evaluation with personalized treatment recommendations',
      'duration': '30 min',
      'price': ' 250',
      'image': 'assets/facialtreatment.jpg',
    },
    // Add more services as needed
    {
      'title': 'Skin Analysis',
      'description': 'Comprehensive skin evaluation with personalized treatment recommendations',
      'duration': '30 min',
      'price': ' 250',
      'image': 'assets/facialtreatment.jpg',
    },
    {
      'title': 'Skin Analysis',
      'description': 'Comprehensive skin evaluation with personalized treatment recommendations',
      'duration': '30 min',
      'price': ' 250',
      'image': 'assets/facialtreatment.jpg',
    },
    {
      'title': 'Skin Analysis',
      'description': 'Comprehensive skin evaluation with personalized treatment recommendations',
      'duration': '30 min',
      'price': ' 250',
      'image': 'assets/facialtreatment.jpg',
    },
    {
      'title': 'Skin Analysis',
      'description': 'Comprehensive skin evaluation with personalized treatment recommendations',
      'duration': '30 min',
      'price': ' 250',
      'image': 'assets/facialtreatment.jpg',
    },
    {
      'title': 'Skin Analysis',
      'description': 'Comprehensive skin evaluation with personalized treatment recommendations',
      'duration': '30 min',
      'price': ' 250',
      'image': 'assets/facialtreatment.jpg',
    },
  ];

  List<bool> selected = List.generate(6, (_) => false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      backgroundColor: Color(0xFFF8F8F8),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStepper(),
              SizedBox(height: 24),
              Text(
                'Select Your Services',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Choose the services you are interested in exploring',
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
              SizedBox(height: 16),
              Text(
                'Please select the services you are interested in:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 16),
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.9, // Reduced from 1.3 to make cards taller
                ),
                itemCount: services.length,
                itemBuilder: (context, index) {
                  return _buildServiceCard(index);
                },
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Back'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pinkAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ConfirmScreen()),
                      );
                    },
                    child: Row(
                      children: [
                        Text('Next'),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward, size: 18),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepper() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _stepCircle(true, '1', 'Personal Info'),
        _stepDivider(),
        _stepCircle(true, '2', 'Select Services', highlight: true),
        _stepDivider(),
        _stepCircle(false, '3', 'Confirm'),
      ],
    );
  }

  Widget _stepCircle(bool completed, String number, String label, {bool highlight = false}) {
    Color color = highlight
        ? Colors.pinkAccent
        : (completed ? Colors.green : Colors.grey[300]!);
    Color textColor = highlight || completed ? Colors.white : Colors.black;
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: color,
          child: Text(number, style: TextStyle(color: textColor)),
        ),
        SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 12, color: highlight ? Colors.pinkAccent : Colors.black)),
      ],
    );
  }

  Widget _stepDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Icon(Icons.chevron_right, color: Colors.grey),
    );
  }

  Widget _buildServiceCard(int index) {
    final service = services[index];
    return GestureDetector(
      onTap: () {
        setState(() {
          selected[index] = !selected[index];
        });
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.asset(
                service['image'],
                height: 80,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Checkbox(
                    value: selected[index],
                    onChanged: (val) {
                      setState(() {
                        selected[index] = val!;
                      });
                    },
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    activeColor: Colors.pinkAccent,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(service['title'], style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 2),
                        Text(
                          service['description'],
                          style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  Icon(Icons.access_time, size: 14, color: Colors.pinkAccent),
                  SizedBox(width: 4),
                  Text(service['duration'], style: TextStyle(fontSize: 12)),
                  Spacer(),
                  Text(service['price'], style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
