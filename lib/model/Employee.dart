import 'dart:ffi';

class Employee {
  int? id;
  String name;
  String role;
  String? toDate;
  String? fromDate;

  Employee(
      {this.id,
      required this.name,
      required this.role,
      this.toDate,
      this.fromDate});

  Map<String, dynamic> toMap({bool includeId = true}) {
    final map = {
      'name': name,
      'role': role,
      'toDate': toDate,
      'fromDate': fromDate,
    };
    if (includeId && id != null) {
      print('id: $id');
      map['id'] = id.toString();
    }
    return map;
  }

  factory Employee.fromMap(Map<String, dynamic> map) {
    return Employee(
      id: int.parse(map['id'].toString()),
      name: map['name'],
      role: map['role'],
      toDate: map['toDate'],
      fromDate: map['fromDate'],
    );
  }

  Employee copyWith({int? id}) {
    return Employee(
      id: id ?? this.id,
      name: name,
      role: role,
      toDate: toDate,
      fromDate: fromDate,
    );
  }
}
