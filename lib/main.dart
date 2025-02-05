import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:realtime_assignment/bloc/employee_bloc.dart';
import 'package:realtime_assignment/bloc/employee_event.dart';
import 'package:realtime_assignment/database/database_helper.dart';
import 'package:realtime_assignment/employee_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) =>
            EmployeeBloc(DatabaseHelper())..add(LoadEmployees()),
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const EmployeeListScreen(),
        ));
  }
}
