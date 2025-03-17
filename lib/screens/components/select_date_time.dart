import 'package:flutter/material.dart';
import 'enter_amount.dart';

class SelectDateTime extends StatefulWidget {
  final String address;
  const SelectDateTime({super.key, required this.address});

  @override
  _SelectDateTimeState createState() => _SelectDateTimeState();
}

class _SelectDateTimeState extends State<SelectDateTime> {
  DateTime _selectedDate = DateTime.now();
  int _selectedHour = 1;
  int _selectedMinute = 0;
  bool _isAM = true;
  String? _selectedAddress;

  // Function to show the date picker
  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2025),
      lastDate: DateTime(2026),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Select date & time"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date Picker Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${_selectedDate.month == 1
                      ? 'January'
                      : _selectedDate.month == 2
                      ? 'February'
                      : _selectedDate.month == 3
                      ? 'March'
                      : _selectedDate.month == 4
                      ? 'April'
                      : _selectedDate.month == 5
                      ? 'May'
                      : _selectedDate.month == 6
                      ? 'June'
                      : _selectedDate.month == 7
                      ? 'July'
                      : _selectedDate.month == 8
                      ? 'August'
                      : _selectedDate.month == 9
                      ? 'September'
                      : _selectedDate.month == 10
                      ? 'October'
                      : _selectedDate.month == 11
                      ? 'November'
                      : 'December'} ${_selectedDate.year}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_left),
                      onPressed: () {
                        setState(() {
                          _selectedDate = DateTime(
                            _selectedDate.year,
                            _selectedDate.month - 1,
                            _selectedDate.day,
                          );
                        });
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_right),
                      onPressed: () {
                        setState(() {
                          _selectedDate = DateTime(
                            _selectedDate.year,
                            _selectedDate.month + 1,
                            _selectedDate.day,
                          );
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Custom Calendar Grid
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                Text("Sun"),
                Text("Mon"),
                Text("Tue"),
                Text("Wed"),
                Text("Thu"),
                Text("Fri"),
                Text("Sat"),
              ],
            ),
            const SizedBox(height: 8),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              itemCount: 42, // Max 6 weeks to display a month
              itemBuilder: (context, index) {
                final firstDayOfMonth = DateTime(
                  _selectedDate.year,
                  _selectedDate.month,
                  1,
                );
                final daysBefore = firstDayOfMonth.weekday % 7;
                final day = index - daysBefore + 1;
                final date = DateTime(
                  _selectedDate.year,
                  _selectedDate.month,
                  day,
                );

                if (index < daysBefore || date.month != _selectedDate.month) {
                  return const SizedBox();
                }

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedDate = date;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:
                          date.day == _selectedDate.day &&
                                  date.month == _selectedDate.month &&
                                  date.year == _selectedDate.year
                              ? Colors.purple
                              : Colors.transparent,
                    ),
                    child: Center(
                      child: Text(
                        day.toString(),
                        style: TextStyle(
                          color:
                              date.day == _selectedDate.day &&
                                      date.month == _selectedDate.month &&
                                      date.year == _selectedDate.year
                                  ? Colors.white
                                  : Colors.black,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),

            // Time Picker Section
            const Text(
              "Select time",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Hour Picker
                SizedBox(
                  width: 60,
                  child: DropdownButton<int>(
                    value: _selectedHour,
                    onChanged: (int? newValue) {
                      setState(() {
                        _selectedHour = newValue!;
                      });
                    },
                    items:
                        List.generate(
                          12,
                          (index) => index + 1,
                        ).map<DropdownMenuItem<int>>((int value) {
                          return DropdownMenuItem<int>(
                            value: value,
                            child: Text(value.toString()),
                          );
                        }).toList(),
                  ),
                ),
                const Text(":", style: TextStyle(fontSize: 18)),
                // Minute Picker
                SizedBox(
                  width: 60,
                  child: DropdownButton<int>(
                    value: _selectedMinute,
                    onChanged: (int? newValue) {
                      setState(() {
                        _selectedMinute = newValue!;
                      });
                    },
                    items:
                        List.generate(
                          60,
                          (index) => index,
                        ).map<DropdownMenuItem<int>>((int value) {
                          return DropdownMenuItem<int>(
                            value: value,
                            child: Text(value.toString().padLeft(2, '0')),
                          );
                        }).toList(),
                  ),
                ),
                // AM/PM Picker
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _isAM = true;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            _isAM ? Colors.purple : Colors.grey[200],
                        foregroundColor: _isAM ? Colors.white : Colors.black,
                        minimumSize: const Size(60, 40),
                      ),
                      child: const Text("AM"),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _isAM = false;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            !_isAM ? Colors.purple : Colors.grey[200],
                        foregroundColor: !_isAM ? Colors.white : Colors.black,
                        minimumSize: const Size(60, 40),
                      ),
                      child: const Text("PM"),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Continue Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Combine date and time into a single DateTime object
                  final selectedDateTime = DateTime(
                    _selectedDate.year,
                    _selectedDate.month,
                    _selectedDate.day,
                    _selectedHour + (_isAM ? 0 : 12),
                    _selectedMinute,
                  );

                  // Navigate to EnterAmount screen with address and dateTime
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AboutYourOrder(
                        address: widget.address,
                        dateTime: selectedDateTime,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text("Continue"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
