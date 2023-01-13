import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:task/modules/archiveTaske.dart';
import 'package:task/modules/doneTaske.dart';
import 'package:task/modules/newTaske.dart';
import 'package:task/stateMangement/cubite.dart';
import 'package:task/stateMangement/states.dart';

import '../constans.dart';
import '../widgets/widgets.dart';

class HomeLayout extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  TextEditingController titleController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubite()..creatDataBase(),
      child: BlocConsumer<AppCubite, AppStates>(listener: (context, state) {
        if (state is AppInsertDataBaseState) {
          Navigator.pop(context);
        }
      }, builder: (context, state) {
        var appCubite = AppCubite.get(context);
        return Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            title: Text(appCubite.listTitle[appCubite.IndexPage]),
          ),
          body: appCubite.listScreen[appCubite.IndexPage],
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              if (appCubite.isShowBottomSheet) {
                if (formKey.currentState!.validate()) {
                  appCubite.insertDataBase(
                      title: titleController.text,
                      date: dateController.text,
                      time: timeController.text);

                  appCubite.ChangeShowBottomSheet(
                      isShowBottom: false, floateIcon: Icons.edit);
                }
              } else {
                appCubite.ChangeShowBottomSheet(
                    isShowBottom: true, floateIcon: Icons.add);
                scaffoldKey.currentState!
                    .showBottomSheet(
                        elevation: 25,
                        (context) => Form(
                              key: formKey,
                              child: Container(
                                color: Colors.white,
                                padding: EdgeInsets.all(20),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    defaultFormField(
                                      controller: titleController,
                                      lable: "Title Text",
                                      prefx: Icons.text_format_sharp,
                                      type: TextInputType.name,
                                      validate: (String? value) {
                                        if (value!.isEmpty) {
                                          return 'Title must not empty';
                                        }
                                        return null;
                                      },
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    defaultFormField(
                                      controller: timeController,
                                      lable: "Time",
                                      prefx: Icons.timelapse_rounded,
                                      type: TextInputType.datetime,
                                      validate: (String? value) {
                                        if (value!.isEmpty) {
                                          return 'Time must not empty';
                                        }
                                        return null;
                                      },
                                      onTap: () {
                                        showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.now(),
                                        ).then((value) {
                                          timeController.text =
                                              value!.format(context).toString();
                                        });
                                      },
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    defaultFormField(
                                      controller: dateController,
                                      lable: "Date",
                                      prefx: Icons.date_range,
                                      type: TextInputType.datetime,
                                      validate: (String? value) {
                                        if (value!.isEmpty) {
                                          return 'date must not empty';
                                        }
                                        return null;
                                      },
                                      onTap: () {
                                        showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(2001),
                                          lastDate: DateTime(2024),
                                        ).then((value) {
                                          dateController.text =
                                              DateFormat.yMMMd()
                                                  .format(value as DateTime);
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ))
                    .closed
                    .then((value) {
                  appCubite.ChangeShowBottomSheet(
                      isShowBottom: false, floateIcon: Icons.edit);
                });
              }
            },
            child: Icon(appCubite.fIcon),
          ),
          bottomNavigationBar: BottomNavigationBar(
              currentIndex: AppCubite.get(context).IndexPage,
              onTap: (value) {
                AppCubite.get(context).changePage(value);
              },
              elevation: 10,
              type: BottomNavigationBarType.fixed,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.menu),
                  label: "Tasks",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.done_outlined),
                  label: "Done",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.archive_outlined),
                  label: "Archived",
                ),
              ]),
        );
      }),
    );
  }
}
