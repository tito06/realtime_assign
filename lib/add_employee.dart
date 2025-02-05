import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:realtime_assignment/bloc/employee_bloc.dart';
import 'package:realtime_assignment/bloc/employee_event.dart';
import 'package:realtime_assignment/model/Employee.dart';

class AddEmployeeScreen extends StatefulWidget {
  final Employee? employee;
  AddEmployeeScreen({this.employee});

  @override
  State<AddEmployeeScreen> createState() => _AddEmployeeScreenState();
}

class _AddEmployeeScreenState extends State<AddEmployeeScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  String? _selectedRole;
  DateTime? _toDate;
  DateTime? _fromDate;

  final List<String> _roles = [
    'Manager',
    'Developer',
    'Designer',
    'Tester',
    'HR'
  ];

  @override
  void initState() {
    super.initState();

    if (widget.employee != null) {
      _nameController.text = widget.employee!.name;
      _selectedRole = widget.employee!.role;

      _toDate = widget.employee!.toDate != null
          ? DateTime.tryParse(widget.employee!.toDate!)
          : null;

      _fromDate = widget.employee!.fromDate != null
          ? DateTime.tryParse(widget.employee!.fromDate!)
          : null;
    }
  }

  Future<void> _selectDate(BuildContext context, DateTime? initialDate,
      Function(DateTime) onDateSelected) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        onDateSelected(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.employee == null ? 'Add Employee' : 'Edit Employee',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.teal,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal),
                  ),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a name' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedRole,
                items: _roles.map((role) {
                  return DropdownMenuItem(
                    value: role,
                    child: Text(role),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedRole = value;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Role',
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal),
                  ),
                ),
                validator: (value) =>
                    value == null ? 'Please select a role' : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      decoration: const InputDecoration(
                        labelText: 'From Date (Required)',
                        labelStyle: TextStyle(color: Colors.black),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        suffixIcon:
                            Icon(Icons.calendar_today, color: Colors.black),
                      ),
                      onTap: () => _selectDate(context, _fromDate, (date) {
                        setState(() {
                          _fromDate = date;
                        });
                      }),
                      controller: TextEditingController(
                        text: _fromDate != null
                            ? "${_fromDate!.toLocal()}".split(' ')[0]
                            : '',
                      ),
                      validator: (value) =>
                          _fromDate == null ? 'From Date is required' : null,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward, color: Colors.teal),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      decoration: const InputDecoration(
                        labelText: 'To Date (Optional)',
                        labelStyle: TextStyle(color: Colors.black),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        suffixIcon:
                            Icon(Icons.calendar_today, color: Colors.black),
                      ),
                      onTap: () => _selectDate(context, _toDate, (date) {
                        setState(() {
                          _toDate = date;
                        });
                      }),
                      controller: TextEditingController(
                        text: _toDate != null
                            ? "${_toDate!.toLocal()}".split(' ')[0]
                            : '',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final employee = Employee(
                            id: widget.employee?.id,
                            name: _nameController.text,
                            role: _selectedRole!,
                            toDate: _toDate?.toIso8601String() ?? '',
                            fromDate: _fromDate!.toIso8601String(),
                          );
                          context.read<EmployeeBloc>().add(
                              widget.employee == null
                                  ? AddEmployee(employee)
                                  : UpdateEmployee(employee));
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        'Save',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
