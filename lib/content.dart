import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_flashcards/utils.dart';

class ContentPage extends StatefulWidget{
  final List<Question> questions;
  const ContentPage({super.key, required this.questions});
  @override
  State<ContentPage> createState() => _ContentPageState();
}


class _ContentPageState extends State<ContentPage>{
  List<Question> questions = [];
  Question question = Question('', '', '', '', '', true);
  var showingAns = false, isLeftJp = false,  isRightJp = false;

  @override
  void initState(){
    super.initState();
    questions = widget.questions;
    next();
  }
  void next(){
    int index = Random().nextInt(questions.length);
    print(index);
    print(questions.length);
    setState(() {
      question = questions[index];
      showingAns = false; isLeftJp = false; isRightJp = false;
    });
  }
  void onLeftPressed(){
    setState(() {
      isLeftJp = !isLeftJp;
    });
  }
  void onRightPressed(){
    setState(() {
      isRightJp = !isRightJp;
    });
  }
  void onCenterPressed(){
    setState(() {
      if(showingAns){
        next();
        return;
      }
      showingAns = true;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FocusableActionDetector(
        autofocus: true,
        shortcuts: <ShortcutActivator, Intent>{
          LogicalKeySet(LogicalKeyboardKey.arrowLeft): LeftIntent(),
          LogicalKeySet(LogicalKeyboardKey.arrowRight): RightIntent(),
          LogicalKeySet(LogicalKeyboardKey.arrowDown): CenterIntent(),
        },
        actions: {
          LeftIntent: CallbackAction<LeftIntent>(onInvoke: (intent) => onLeftPressed()),
          RightIntent: CallbackAction<RightIntent>(onInvoke: (intent) => onRightPressed()),
          CenterIntent: CallbackAction<CenterIntent>(onInvoke: (intent) => onCenterPressed()) 
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.bodyLarge,
                  children: [
                    TextSpan(
                      text: question.sentenceLeft
                    ),
                    TextSpan(
                      text: showingAns ? question.answer ? question.leftEn : question.rightEn : '_____',
                      style: TextStyle(color: showingAns ? question.answer ? Colors.red : Colors.blue : Colors.black)
                    ),
                    TextSpan(
                      text: question.sentenceRight
                    )
                  ]
                )
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  Expanded(
                    child:
                      Container(
                        alignment: Alignment.centerRight,
                        child: 
                          OutlinedButton(
                            onPressed: onLeftPressed,
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(width: 1, color: Colors.red),
                              foregroundColor: Colors.red
                            ),
                            child: Text(isLeftJp ? question.leftJp : question.leftEn)  
                          )
                      )
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: 
                      Container(
                        alignment: Alignment.centerLeft,
                        child: 
                          OutlinedButton(
                            onPressed: onRightPressed ,
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(width: 1, color: Colors.blue),
                              foregroundColor: Colors.blue
                            ),
                            child: Text(isRightJp ? question.rightJp : question.rightEn)
                          )
                      )
                  ),
              ]),
              const SizedBox(height: 5),
              OutlinedButton(
                onPressed: onCenterPressed,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(width: 1, color: Colors.black),
                  foregroundColor: Colors.black
                ),
                child: Text(showingAns ? 'Next' : 'Show Answer'))
          ])
        )
        )
    );
  }
}

class LeftIntent extends Intent{}
class RightIntent extends Intent{}
class CenterIntent extends Intent{}