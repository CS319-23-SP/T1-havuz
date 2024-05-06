import 'package:first_trial/Pages/Widgets/AppBars/app_bars.dart';
import 'package:first_trial/Pages/Widgets/LeftBar/left_bar.dart';
import 'package:first_trial/token.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';

class CreateAssignmentPage extends StatefulWidget {
  const CreateAssignmentPage({super.key, required this.sectionID});
  final String sectionID;

  @override
  State<CreateAssignmentPage> createState() => _CreateAssignmentPageState();
}

class _CreateAssignmentPageState extends State<CreateAssignmentPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController headerController = TextEditingController();
  final TextEditingController topicsController = TextEditingController();
  final TextEditingController textController = TextEditingController();
  final term = "2024 Spring";
  DateTime finalDay = DateTime(2024, 05, 31);
  String? role = "unknown";
  var deadline;
  @override
  void initState() {
    super.initState();
    checkRole();
    String? sectionId = widget.sectionID;
  }

  Future<void> checkRole() async {
    role = await TokenStorage.getRole();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(role: role),
      body: Row(
        children: [
          LeftBar(role: role),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    /*MultiSelectDropDown(
                        onOptionSelected: (List<ValueItem> selectedOptions) {
                          setState(() {
                            selectedCourses.clear();
                            selectedCourses.addAll(selectedOptions
                                .map((option) => option.value as String));
                          });
                        },
                        options: courseOptions,
                        controller: _controller,
                      ),*/
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'Assignment Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      controller: headerController,
                      decoration: InputDecoration(
                        labelText: 'Assignment Header',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 20),
                    InkWell(
                      onTap: () {
                        showDatePicker(
                          context: context,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2050),
                        ).then((pickedDate) {
                          if (pickedDate != null) {
                            setState(() {
                              deadline = pickedDate;
                            });
                          }
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          deadline != null
                              ? 'End: ${DateFormat('yyyy-MM-dd').format(deadline!)}'
                              : 'Deadline',
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      controller: topicsController,
                      decoration: InputDecoration(
                        labelText: 'Assignment Topics',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      controller: textController,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        labelText: 'Assignment Text',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: () {
                        //createQuestion();
                      },
                      child: Text('Create Assignment'),
                    ),
                    Container(
                      width: 60,
                      child: IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: () {
                          GoRouter.of(context).go('/instructor');
                        },
                      ),
                    ),
                  ]),
            ),
          ),
        ],
      ),
    );
  }
}
