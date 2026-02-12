import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:schoole/ui/screens/schedule/student_schedule.dart';
import 'package:schoole/ui/screens/schedule/teacher_schedule.dart';
import '../../constants.dart';

class Schedule_Screen extends StatelessWidget {
  const Schedule_Screen({super.key});

  @override
  Widget build(BuildContext context) {
    double height=MediaQuery.of(context).size.height;
    double width=MediaQuery.of(context).size.width;
    return ConditionalBuilder(
        condition: isteacher==true,
        builder: (context)=>Schedule_Screen_Teacher(),
        fallback: (context)=>Schedule_Screen_Student());
  }
}



//Teacher_sch(width: width, height: height, day: 'sunday')
/*  SizedBox(
                                          width: width/0.33,
                                          child:AlignedGridView.count(
                                            padding: EdgeInsets.only(top: 50),
                                            crossAxisCount: 7,itemCount: 34,
                                            itemBuilder: (context, index) {
                                              return
                                                (index==27)?SizedBox():
                                                (index==0||index==1||index==2||index==3||index==4||index==5||index==6)?start():
                                                (index==7||index==8||index==9||index==10||index==11||index==12||index==13)?Text('monday'):
                                                (index==14||index==15||index==16||index==17||index==18||index==19||index==20)?Text('tesday'):
                                                (index==21||index==22||index==23||index==24||index==25||index==26||index==27)?Text('wednsday'):
                                                (index==28||index==29||index==30||index==31||index==32||index==33)?Text('thursday'):
                                                Text('$index');
                                            },
                                          ) ,
                                        )*/