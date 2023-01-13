import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:task/stateMangement/cubite.dart';

Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType type,
  Function(String)? onSubmite,
  Function(String)? onChange,
  VoidCallback? onTap,
  bool isPassword = false,
  required   validate,
  required String lable,
  required IconData prefx,
  IconData? suffix,
  VoidCallback? suffixPassword,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: type,
      obscureText: isPassword,
      onTap: onTap,
      onChanged: onChange,
      onFieldSubmitted: onSubmite,
       validator: validate ,
      decoration: InputDecoration(
          labelText: lable,
          prefixIcon: Icon(prefx),
          suffixIcon: suffix != null
              ? IconButton(
                  onPressed: suffixPassword,
                  icon: Icon(suffix),
                )
              : null,
          border: OutlineInputBorder()),
    );

Widget taskeBuilder(Map task, context) => Dismissible(
      key: Key(task['id'].toString()),
      onDismissed: (direction) {
        AppCubite.get(context).deleteDataDataBase(id: task['id']);
      },
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(children: [
          CircleAvatar(
            radius: 40,
            child: Text("${task['time']}"),
          ),
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${task['tilte']}',
                  style: TextStyle(
                    fontSize: 22,
                  ),
                ),
                Text(
                  '${task['date']}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 20,
          ),
          IconButton(
              onPressed: () {
                AppCubite.get(context)
                    .updateDataDataBase(status: 'done', id: task['id']);
              },
              icon: Icon(
                Icons.check_box,
                color: Colors.green,
              )),
          IconButton(
              onPressed: () {
                AppCubite.get(context)
                    .updateDataDataBase(status: 'archived', id: task['id']);
              },
              icon: Icon(
                Icons.archive_rounded,
                color: Colors.black45,
              )),
        ]),
      ),
    );



Widget taskeCondition(List<Map>listTask)=> ConditionalBuilder(
          condition: listTask.length > 0,
          builder: (context) => ListView.separated(
              itemBuilder: (context, index) =>
                  taskeBuilder(listTask[index], context),
              separatorBuilder: (context, index) => Padding(
                    padding: const EdgeInsetsDirectional.only(start: 20),
                    child: Container(
                      width: double.infinity,
                      height: 2,
                      color: Colors.grey,
                    ),
                  ),
              itemCount:listTask.length),
          fallback: (context) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.menu,
                  size: 120,
                  color: Colors.grey,
                ),
                Text(
                  'No Tasks Yet, Please App Some Tasks',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
        );
     