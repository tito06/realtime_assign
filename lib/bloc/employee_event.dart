import 'package:equatable/equatable.dart';
import 'package:realtime_assignment/model/Employee.dart';

abstract class EmployeeEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadEmployees extends EmployeeEvent {}

class AddEmployee extends EmployeeEvent {
  final Employee employee;
  AddEmployee(this.employee);

  @override
  List<Object?> get props => [employee];
}

class UpdateEmployee extends EmployeeEvent {
  final Employee employee;
  UpdateEmployee(this.employee);

  @override
  List<Object?> get props => [employee];
}

class DeleteEmploye extends EmployeeEvent {
  final int id;
  DeleteEmploye(this.id);

  @override
  List<Object?> get props => [id];
}
