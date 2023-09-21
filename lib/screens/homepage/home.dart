import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:renconsport/provider/state.dart';
import 'package:renconsport/widgets/appbar.dart';
import 'package:renconsport/widgets/bottomappbar.dart';
import 'package:renconsport/widgets/message/message_widget.dart';
import 'package:renconsport/widgets/profile/profile_widget.dart';
import 'package:renconsport/widgets/swipe/swipe.dart';
import 'package:renconsport/widgets/training/training_widget.dart';

class Home extends ConsumerStatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  @override
  Widget build(BuildContext context) {
    final index = ref.watch(currentIndexProvider);

    List<Widget> widgets = [
      SwipeCard(),
      Profile(),
      MessagePage(),
      TrainingList()
    ];

    return Scaffold(
      // appBar: CustomAppBar(showBackButton: true),
      body: widgets[index],
      bottomNavigationBar: CustomNavigationBar(
        onTap: (newIndex) {
          ref.read(currentIndexProvider.notifier).state = newIndex;
        },
      ),
    );
  }
}
