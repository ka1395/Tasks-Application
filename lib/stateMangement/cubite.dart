import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import '../modules/archiveTaske.dart';
import '../modules/doneTaske.dart';
import '../modules/newTaske.dart';
import 'states.dart';

class AppCubite extends Cubit<AppStates> {
  AppCubite() : super(AppInitilaState());
  static AppCubite get(context) => BlocProvider.of(context);

  int IndexPage = 0;
  List<Widget> listScreen = [
    NewTaskeScreen(),
    DoneTaskeScreen(),
    ArchiveTaskScreen(),
  ];
  List<String> listTitle = [
    'Tasks',
    'Done',
    'Archived',
  ];
  changePage(int newIndex) {
    IndexPage = newIndex;
    emit(AppChangeNavigationBarState());
  }

  bool isShowBottomSheet = false;
  IconData fIcon = Icons.edit;

  void ChangeShowBottomSheet(
      {required bool isShowBottom, required IconData floateIcon}) {
    isShowBottomSheet = isShowBottom;
    fIcon = floateIcon;

    emit(AppChangeNavigationBarState());
  }

  late Database dataBase;
  List<Map> tasks = [];

  List<Map> newtasks = [];
  List<Map> donetasks = [];
  List<Map> archivedtasks = [];
  void creatDataBase() {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (dataBase, version) {
        print('create Database');
        dataBase
            .execute(
                'CREATE TABLE tasks (id INTEGER PRIMARY KEY, tilte TEXT, date TEXT, time TEXT , status TEXT)')
            .then((value) {
          print('create Table');
        }).catchError((onError) {
          print('error at ceate Table ${onError} ');
        });
      },
      onOpen: (dataBase) {
        getDataFromDataBase(dataBase);
        print('open Database');
      },
    ).then((value) {
      dataBase = value;
      emit(AppCreatDataBaseState());
    });
  }

  Future insertDataBase(
      {required String title,
      required String date,
      required String time}) async {
    return await dataBase.transaction((txn) async {
      await txn
          .rawInsert(
        'INSERT INTO tasks(tilte, date, time ,status) VALUES("$title","$date","$time","new")',
      )
          .then((value) {
        print('Insert successful at :${value}');
        emit(AppInsertDataBaseState());

        getDataFromDataBase(dataBase);
      }).catchError((onError) {
        print('Erorr : Insert ${onError}');
      });
    });
  }

  void getDataFromDataBase(db) async {
    db!.rawQuery('SELECT * FROM tasks').then((value) {
      newtasks = [];
      donetasks = [];
      archivedtasks = [];
      value.forEach((element) {
        if (element['status'] == 'new') {
          newtasks.add(element);
        } else if (element['status'] == 'done') {
          donetasks.add(element);
        } else {
          archivedtasks.add(element);
        }
        tasks = value;
      });
      print("new list =     ${newtasks}");
      print("new list =     ${donetasks}");
      print("new list =     ${archivedtasks}");
      emit(AppGetDataBaseState());
    });
  }

  void updateDataDataBase({
    required String status,
    required int id,
  }) {
    dataBase.rawUpdate('UPDATE tasks SET status = ? WHERE id = ?',
        ['${status}', id]).then((value) {
      getDataFromDataBase(dataBase);
    });
  }

  void deleteDataDataBase({
    required int id,
  }) {
    dataBase.rawUpdate('DELETE FROM tasks WHERE id = ?', [id]).then((value) {
      getDataFromDataBase(dataBase);
      emit(AppdeleteDataBaseState());
    });
  }
}
