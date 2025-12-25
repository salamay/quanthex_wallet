import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:quanthex/data/controllers/home/home_controller.dart';
import 'package:quanthex/data/controllers/mining/mining_controller.dart';

import '../../widgets/bottom_nav_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        padding: EdgeInsets.all(8.sp),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: Consumer<HomeController>(
          builder: (context, homeCtr, child) {
            int currentIndex = homeCtr.index;
            return SafeArea(
              child: IndexedStack(
                  index: homeCtr.index,
                  children: homeCtr.dashboards
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: Consumer<HomeController>(
          builder: (context, homeCtr, child) {
          return BottomNavBar(currentIndex: homeCtr.index);
        }
      ),
    );
  }
}
