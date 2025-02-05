import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:realtime_assignment/bloc/employee_event.dart';
import 'package:realtime_assignment/bloc/employee_state.dart';
import 'package:realtime_assignment/database/database_helper.dart';

class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {
  final DatabaseHelper databaseHelper;

  EmployeeBloc(this.databaseHelper) : super(EmployeeInitial()) {
    on<LoadEmployees>((event, emit) async {
      emit(EmployeeLoading());

      try {
        final employees = await databaseHelper.getEmployees();
        emit(EmployeeLoaded(employees));
      } catch (e) {
        emit(EmployeeError("Failed to load data"));
      }
    });

    on<AddEmployee>((event, emit) async {
      await databaseHelper.insertEmployee(event.employee);
      add(LoadEmployees());
    });

    on<UpdateEmployee>((event, emit) async {
      await databaseHelper.updateEmployee(event.employee);
      add(LoadEmployees()); // Reload list after update
    });

    on<DeleteEmploye>((event, emit) async {
      await databaseHelper.deleteEmployee(event.id);
      add(LoadEmployees()); // Reload list after deletion
    });
  }
}
