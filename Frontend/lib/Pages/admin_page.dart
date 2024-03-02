import 'package:flutter/material.dart';
import 'student_create_page.dart';
import 'student.dart';

class Admin extends StatefulWidget {
  @override
  _AdminState createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  List<Student> students = [
    Student(id: '3131', name: 'Arda', course: 'CS 331'),
    Student(id: '3132', name: 'Arda', course: 'CS 331'),
    Student(id: '3133', name: 'Arda', course: 'CS 331'),
    Student(id: '3134', name: 'Arda', course: 'CS 331'),
  ];

  void addStudent(Student student) {
    setState(() {
      students.add(student);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Admin')),
        body: StudentData(students: students, onDelete: (index) {
          setState(() {
            students.removeAt(index);
          });
        }),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => StudentCreationPage(
                onCreateStudent: addStudent,
              )),
            );
          },
          backgroundColor: Colors.blue,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class StudentData extends StatelessWidget {
  final List<Student> students;
  final Function(int) onDelete;

  const StudentData({
    Key? key,
    required this.students,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: students.length,
      itemBuilder: (context, index) {
        var student = students[index];
        return ListTile(
          title: Text('${student.id} - ${student.name} - ${student.course}'),
          trailing: IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => onDelete(index),
          ),
        );
      },
    );
  }
}
