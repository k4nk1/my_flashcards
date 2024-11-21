import 'package:flutter/material.dart';
import 'package:my_flashcards/content.dart';
import 'package:my_flashcards/utils.dart';

class TitlePage extends StatefulWidget{
  const TitlePage({super.key});
  @override
  State<TitlePage> createState() => _TitlePageState();
}

class _TitlePageState extends State<TitlePage>{
  bool isLoading = false;
  void startMain() async {
    if(isLoading) return;
    isLoading = true;
    List<Question> questions = await Utils.getQuestionsFromAPI();
    if(!mounted) return;
    Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) => ContentPage(
          questions: questions
        )
      )
    );
    isLoading = false;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: OutlinedButton(
          onPressed: startMain,
          child: const Text('=>')
        )
      )
    );
  }
}