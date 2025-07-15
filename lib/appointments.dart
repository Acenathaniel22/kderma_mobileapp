import 'package:flutter/material.dart';

class AppointmentPage extends StatefulWidget {
  const AppointmentPage({super.key});

  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Appointment> _filteredAppointments = [];
  String? _selectedStatus;

  @override
  void initState() {
    super.initState();
    _filteredAppointments = AppointmentStore().appointments;
    _searchController.addListener(_filterAppointments);
  }

  void _filterAppointments() {
    final query = _searchController.text.toLowerCase();

    setState(() {
      _filteredAppointments = AppointmentStore().appointments.where((appt) {
        final matchesSearch = appt.clientName.toLowerCase().contains(query) ||
            appt.service.toLowerCase().contains(query) ||
            (appt.staffName ?? '').toLowerCase().contains(query) ||
            appt.status.toLowerCase().contains(query);

        final matchesStatus = _selectedStatus == null || appt.status == _selectedStatus;

        return matchesSearch && matchesStatus;
      }).toList();
    });
  }

  void _showFilterOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: [
            ListTile(
              title: const Text('All'),
              onTap: () {
                setState(() {
                  _selectedStatus = null;
                });
                _filterAppointments();
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Pending'),
              onTap: () {
                setState(() {
                  _selectedStatus = 'Pending';
                });
                _filterAppointments();
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Confirmed'),
              onTap: () {
                setState(() {
                  _selectedStatus = 'Confirmed';
                });
                _filterAppointments();
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Rejected'),
              onTap: () {
                setState(() {
                  _selectedStatus = 'Rejected';
                });
                _filterAppointments();
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appointments = _filteredAppointments;
    return Scaffold(
      backgroundColor: const Color(0xFFFFF5F7),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Appointments",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Search
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 48,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.pink.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: "Search appointments...",
                          border: InputBorder.none,
                          icon: Icon(Icons.search),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Filter Button
                  Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.filter_list),
                      onPressed: () {
                        _showFilterOptions();
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Upcoming Appointments
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Upcoming Appointments",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${appointments.length} appointment${appointments.length == 1 ? '' : 's'} scheduled for 2025",
                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      const SizedBox(height: 12), // Optional spacing
                      Expanded( // Wrap in Expanded to avoid unbounded height error
                        child: appointments.isEmpty
                            ? const Center(child: Text("No appointments yet."))
                            : ListView.builder(
                          itemCount: appointments.length,
                          itemBuilder: (context, index) {
                            final appt = appointments[index];
                            return appointmentCard(
                              name: (appt.staffName != null && appt.staffName!.isNotEmpty)
                                  ? appt.staffName!
                                  : 'Aesthetician',
                              time: _formatDateTime(appt.dateTime),
                              service: appt.service,
                              status: appt.status,
                              duration: '${appt.durationMinutes} min',
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Appointment {
  final String clientName;
  final String service;
  final DateTime dateTime;
  final int durationMinutes;
  final String status;
  final String? staffName;

  Appointment({
    required this.clientName,
    required this.service,
    required this.dateTime,
    required this.durationMinutes,
    required this.status,
    this.staffName,
  });
}

class AppointmentStore {
  static final AppointmentStore _instance = AppointmentStore._internal();
  factory AppointmentStore() => _instance;
  AppointmentStore._internal();

  final List<Appointment> _appointments = [];

  List<Appointment> get appointments => List.unmodifiable(_appointments);

  void add(Appointment appointment) {
    _appointments.add(appointment);
  }

  void clear() {
    _appointments.clear();
  }
}

// Helper function for formatting date/time
String _formatDateTime(DateTime dt) {
  final date =
      "${dt.year.toString().padLeft(4, '0')}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}";
  final hour = dt.hour > 12 ? dt.hour - 12 : dt.hour;
  final ampm = dt.hour >= 12 ? 'PM' : 'AM';
  final minute = dt.minute.toString().padLeft(2, '0');
  return "$date at $hour:$minute $ampm";
}

Widget appointmentCard({
  required String name,
  required String time,
  required String service,
  required String status,
  required String duration,
}) {
  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.pink.shade50),
      borderRadius: BorderRadius.circular(12),
      color: Colors.white,
    ),
    child: Row(
      children: [
        Icon(Icons.calendar_month, color: Colors.pink[300]),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.pink[300],
                  )),
              const SizedBox(height: 4),
              Text(time, style: const TextStyle(color: Colors.grey)),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(service, style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.access_time, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(duration, style: const TextStyle(fontSize: 12)),
              ],
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                status,
                style: const TextStyle(color: Colors.white, fontSize: 10),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
