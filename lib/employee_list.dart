import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:realtime_assignment/add_employee.dart';
import 'package:realtime_assignment/bloc/employee_bloc.dart';
import 'package:realtime_assignment/bloc/employee_event.dart';
import 'package:realtime_assignment/bloc/employee_state.dart';
import 'package:realtime_assignment/model/Employee.dart';

class EmployeeListScreen extends StatefulWidget {
  const EmployeeListScreen({super.key});

  @override
  State<EmployeeListScreen> createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen> {
  @override
  void initState() {
    super.initState();
    context.read<EmployeeBloc>().add(LoadEmployees());
  }

  String formatDate(String date) {
    try {
      // Convert the string to DateTime
      final parsedDate = DateTime.parse(date);
      // Format the date into a more readable format
      return DateFormat('yyyy-MM-dd').format(parsedDate);
    } catch (e) {
      return date; // Return the original date string if parsing fails
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Employee List",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.teal,
      ),
      body: BlocBuilder<EmployeeBloc, EmployeeState>(
        builder: (context, state) {
          if (state is EmployeeLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is EmployeeLoaded) {
            // Separate employees into current and previous employees
            List<Employee> currentEmployees = [];
            List<Employee> previousEmployees = [];
            for (var employee in state.employees) {
              if (employee.toDate!.isEmpty) {
                currentEmployees.add(employee); // No "to date" means current
              } else {
                previousEmployees.add(employee); // "To date" means previous
              }
            }

            return ListView(
              children: [
                if (currentEmployees.isNotEmpty)
                  // Display Current Employees if there are any
                  Container(
                    color: Colors.grey[300], // Grey background
                    padding: const EdgeInsets.all(8.0),
                    child: const Text(
                      "Current Employees",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.teal,
                      ),
                    ),
                  ),
                if (currentEmployees.isNotEmpty)
                  ...currentEmployees.map((employee) {
                    return ListTile(
                      title: Text(employee.name),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(employee.role),
                          Text('From: ${formatDate(employee.fromDate!)}'),
                          if (employee.toDate != null &&
                              employee.toDate!.isNotEmpty)
                            Text('To: ${formatDate(employee.toDate!)}'),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      AddEmployeeScreen(employee: employee),
                                ),
                              );
                              // Refresh the list after returning from the edit screen
                              context.read<EmployeeBloc>().add(LoadEmployees());
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              context
                                  .read<EmployeeBloc>()
                                  .add(DeleteEmploye(employee.id!));
                            },
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                if (previousEmployees.isNotEmpty)
                  // Display Previous Employees if there are any
                  Container(
                    color: Colors.grey[300], // Grey background
                    padding: const EdgeInsets.all(8.0),
                    child: const Text(
                      "Previous Employees",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.teal,
                      ),
                    ),
                  ),
                if (previousEmployees.isNotEmpty)
                  ...previousEmployees.map((employee) {
                    return ListTile(
                      title: Text(employee.name),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(employee.role),
                          Text('From: ${formatDate(employee.fromDate!)}'),
                          Text('To: ${formatDate(employee.toDate ?? "N/A")}'),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      AddEmployeeScreen(employee: employee),
                                ),
                              );
                              // Refresh the list after returning from the edit screen
                              context.read<EmployeeBloc>().add(LoadEmployees());
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              context
                                  .read<EmployeeBloc>()
                                  .add(DeleteEmploye(employee.id!));
                            },
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                if (currentEmployees.isEmpty && previousEmployees.isEmpty)
                  const Center(child: Text("No Data Available")),
              ],
            );
          } else if (state is EmployeeError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text('Press + to add an employee'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddEmployeeScreen()),
          );
          // Reload the employee list after returning from the add screen
          context.read<EmployeeBloc>().add(LoadEmployees());
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.teal,
      ),
    );
  }
}
