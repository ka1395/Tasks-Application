import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../stateMangement/cubite.dart';
import '../stateMangement/states.dart';
import '../widgets/widgets.dart';

class ArchiveTaskScreen extends StatelessWidget {
  const ArchiveTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubite, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var Cubite = AppCubite.get(context);
        var listTask = Cubite.archivedtasks;
        return taskeCondition(listTask);
      },
    );
  }
}
