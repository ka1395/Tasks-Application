import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task/constans.dart';
import 'package:task/stateMangement/cubite.dart';
import 'package:task/stateMangement/states.dart';

import '../widgets/widgets.dart';

class NewTaskeScreen extends StatelessWidget {
  const NewTaskeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubite, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var Cubite = AppCubite.get(context);
        var listTask = Cubite.newtasks;

        return taskeCondition(listTask);
      },
    );
  }
}
