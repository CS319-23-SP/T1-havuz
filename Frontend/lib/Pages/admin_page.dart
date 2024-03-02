import 'package:flutter/material.dart';
import 'student_create_page.dart';

class Admin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Admin')),
        body: StudentData(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => StudentCreationPage()),);
          },
          backgroundColor: Colors.blue,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class StudentData extends StatefulWidget {
  @override
  _StudentDataState createState() => _StudentDataState();
}

class _StudentDataState extends State<StudentData> {
  List<Student> students = [
    Student(id: '3131', name: 'Arda', course: 'CS 331'),
    Student(id: '3132', name: 'Arda', course: 'CS 331'),
    Student(id: '3133', name: 'Arda', course: 'CS 331'),
    Student(id: '3134', name: 'Arda', course: 'CS 331'),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: students.length,
      itemBuilder: (context, index) {
        var student = students[index];
        return ListTile(
          title:
              Text('${student.id} - ${student.name} - ${student.course}'),
          trailing:
              IconButton(icon:
                const Icon(Icons.delete, color: Colors.red), onPressed:
                    () { setState(() {students.removeAt(index);});}),
        );
      },
    );
  }
}

class Student {
 String id;
 String name;
 String course;

 Student({required this.id, required this.name, required this.course});
}
