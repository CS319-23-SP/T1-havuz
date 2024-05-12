import 'package:first_trial/Objects/evaluation.dart';
import 'package:first_trial/Pages/Widgets/AppBars/app_bars.dart';
import 'package:first_trial/Pages/Widgets/LeftBar/left_bar.dart';
import 'package:first_trial/Pages/Widgets/success_fail.dart';
import 'package:first_trial/final_variables.dart';
import 'package:first_trial/token.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EvaluationPage extends StatefulWidget {
  const EvaluationPage({super.key, required this.sectionID});
  final String sectionID;

  @override
  State<EvaluationPage> createState() => _EvaluationPageState();
}

class _EvaluationPageState extends State<EvaluationPage> {
  final TextEditingController courseEvaController = TextEditingController();
  final TextEditingController instrEvaController = TextEditingController();
  List<Evaluation> evaluations = [];
  String? term = PoolTerm.term;
  String? role = "unknown";
  @override
  void initState() {
    super.initState();
    checkRole();
  }

  Future<void> checkRole() async {
    role = await TokenStorage.getRole();
    if (role == "instructor") {
      fetchEvaluations();
    }
    setState(() {});
  }

  Future<void> fetchEvaluations() async {
    try {
      String? token = await TokenStorage.getToken();
      if (token == null) {
        throw Exception('Token not found');
      }
      String? ID = await TokenStorage.getID();
      String sectionID = widget.sectionID;
      final response = await http.get(
        Uri.http('localhost:8080', '/evaluation/$term/$sectionID'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print(responseData['evaluations']);
        setState(() {
          evaluations = parseEvaluationData(responseData['evaluations']);
        });
      } else {
        throw Exception('Failed to fetch courses data');
      }
    } catch (e) {
      print('Error fetching s: $e');
    }
  }

  List<Evaluation> parseEvaluationData(dynamic responseData) {
    print(responseData);
    return (responseData as List<dynamic>)
        .map((otuzbir) => Evaluation.fromJson(otuzbir))
        .toList();
  }

  makeEvaluation() async {
    String? token = await TokenStorage.getToken();
    if (token == null) {
      throw Exception('Token not found');
    }
    final course = courseEvaController.text;
    final instr = instrEvaController.text;

    final sectionID = widget.sectionID;

    print(sectionID);
    final url = Uri.parse('http://localhost:8080/evaluation/$term/$sectionID');
    Map<String, dynamic> requestBody = {
      'courseMessage': course,
      'instructorMessage': instr,
    };

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(requestBody),
    );
    if (response.statusCode > 199 && response.statusCode < 212) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return SuccessWidget(
            context: context,
            onDismiss: () {
              courseEvaController.clear();
              instrEvaController.clear();
              GoRouter.of(context).go("/$role");
            },
          );
        },
      );
    } else {
      print('Failed to create question: ${response.reasonPhrase}');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return FailWidget(
            context: context,
            onDismiss: () {},
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(role: role),
        body: role == "student"
            ? Center(
                child: Column(
                  children: [
                    TextFormField(
                      controller: courseEvaController,
                      decoration: InputDecoration(
                        labelText: 'Kurs nasıldı?',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      controller: instrEvaController,
                      decoration: InputDecoration(
                        labelText: 'Anıl hoca nasıl birisi anlatsana biraz? ',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: () {
                        makeEvaluation();
                      },
                      child: Text('Make evalutaion'),
                    ),
                  ],
                ),
              )
            : role == "instructor"
                ? Center(
                    child: ListView.builder(
                      itemCount: evaluations.length,
                      itemBuilder: (context, index) {
                        final evaluation = evaluations[index];
                        return ListTile(
                          title: Text(
                              'Course Message: ${evaluation.courseMessage}'),
                          subtitle: Text(
                              'Instructor Message: ${evaluation.instructorMessage}'),
                        );
                      },
                    ),
                  )
                : Container());
  }
}
