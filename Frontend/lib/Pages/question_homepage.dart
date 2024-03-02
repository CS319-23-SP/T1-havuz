import 'package:first_trial/Pages/Widgets/AppBars/app_bars.dart';
import 'package:first_trial/final_variables.dart';
import 'package:flutter/material.dart';

class QuestionHomepage extends StatefulWidget {
  const QuestionHomepage({super.key});

  @override
  State<QuestionHomepage> createState() => _QuestionHomepageState();
}

class _QuestionHomepageState extends State<QuestionHomepage> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: const InstructorAppBar(),
      body: Row(
        children: [
          Padding(
            padding: EdgeInsets.all(screenHeight / 7),
            child: Row(
              children: [
                SizedBox(
                  width: 2 * (screenWidth / 7) / 14,
                ),
                Container(
                  decoration: const BoxDecoration(
                      color: PoolColors.cardWhite,
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  child: SizedBox(
                    width: screenWidth / 4,
                    height: 3 * (screenHeight / 4),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: PoolColors.black),
                                color: PoolColors.fairTurkuaz,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(15))),
                            child: const Padding(
                              padding: EdgeInsets.only(left: 12.0),
                              child: TextField(
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  labelText: "labelText",
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: PoolColors.black),
                                color: PoolColors.fairTurkuaz,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(15))),
                            child: const Padding(
                              padding: EdgeInsets.only(left: 12.0),
                              child: TextField(
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  labelText: "labelText",
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: PoolColors.black),
                                color: PoolColors.fairTurkuaz,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(15))),
                            child: const Padding(
                              padding: EdgeInsets.only(left: 12.0),
                              child: TextField(
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  labelText: "labelText",
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: PoolColors.black),
                                color: PoolColors.fairTurkuaz,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(15))),
                            child: const Padding(
                              padding: EdgeInsets.only(left: 12.0),
                              child: TextField(
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  labelText: "labelText",
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            height: screenHeight / 14,
                            width: 3 * (8 * (screenWidth / 7) / 14) / 2,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    const MaterialStatePropertyAll<Color>(
                                  PoolColors.fairBlue,
                                ),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                              ),
                              onPressed: () {},
                              child: const Text(
                                'Search',
                                style: TextStyle(
                                    color: PoolColors.black, fontSize: 25),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                top: screenHeight / 7, bottom: screenHeight / 7),
            child: SizedBox(
              width: screenWidth / 2,
              child: Container(
                decoration: const BoxDecoration(
                    color: PoolColors.cardWhite,
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(screenHeight / 30),
                      child: SizedBox(
                        height: screenHeight / 15,
                        width: 3 * screenWidth / 7,
                        child: Container(
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              //border: Border.all(color: PoolColors.black),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          child: Row(
                            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: screenWidth / 14,
                                decoration: BoxDecoration(
                                    border: Border.all(color: PoolColors.black),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15))),
                                height: screenHeight / 15,
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        const MaterialStatePropertyAll<Color>(
                                      PoolColors.fairTurkuaz,
                                    ),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                  ),
                                  onPressed: () {},
                                  child: const Text(
                                    'Question ID',
                                    style: TextStyle(
                                        color: PoolColors.black, fontSize: 16),
                                  ),
                                ),
                              ),
                              Container(
                                width: 3 * screenWidth / 28,
                                decoration: BoxDecoration(
                                    border: Border.all(color: PoolColors.black),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(15))),
                                height: screenHeight / 15,
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        const MaterialStatePropertyAll<Color>(
                                      PoolColors.fairTurkuaz,
                                    ),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                  ),
                                  onPressed: () {},
                                  child: const Text(
                                    'Question Name',
                                    style: TextStyle(
                                        color: PoolColors.black, fontSize: 18),
                                  ),
                                ),
                              ),
                              Container(
                                width: screenWidth / 14,
                                decoration: BoxDecoration(
                                    border: Border.all(color: PoolColors.black),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(15))),
                                height: screenHeight / 15,
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        const MaterialStatePropertyAll<Color>(
                                      PoolColors.fairTurkuaz,
                                    ),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                  ),
                                  onPressed: () {},
                                  child: const Text(
                                    'Courses',
                                    style: TextStyle(
                                        color: PoolColors.black, fontSize: 18),
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    border: Border.all(color: PoolColors.black),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(15))),
                                height: screenHeight / 15,
                                width: 5 * screenWidth / 28 - 2,
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        const MaterialStatePropertyAll<Color>(
                                      PoolColors.fairTurkuaz,
                                    ),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                  ),
                                  onPressed: () {},
                                  child: const Text(
                                    'Keywords',
                                    style: TextStyle(
                                        color: PoolColors.black, fontSize: 18),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: screenHeight / 30,
                        right: screenHeight / 30,
                      ),
                      child: SizedBox(
                        height: screenHeight / 2,
                        width: 3 * screenWidth / 7,
                        child: Container(
                          decoration: BoxDecoration(
                              color: PoolColors.white,
                              border: Border.all(color: PoolColors.black),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(15))),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
