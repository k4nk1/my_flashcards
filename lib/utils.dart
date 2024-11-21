import 'dart:convert';

import 'package:http/http.dart' as http;

class Question{
  String sentenceLeft='', sentenceRight='', leftEn, rightEn, leftJp, rightJp;
  bool answer; //true : left is corrent, false : right is corrent.
  Question(String sentence, this.leftEn, this.rightEn, this.leftJp, this.rightJp, this.answer){
    List<String> splitted = sentence.split('^');
    sentenceLeft = splitted[0];
    sentenceRight = splitted.length == 2 ? splitted[1] : '';
  }
}

class Utils{
  static String sheetUrl = '18LDtb9w-ERueqPGh_D14ZbgfHLQ7UWXGfEGDQm7Qbmg';
  static String sheetName = 'main';
  static String apiKey = 'AIzaSyAFT1ms4C4qpXzw9kbYEq3omS1_fD3n0no';
  static String url = 'https://sheets.googleapis.com/v4/spreadsheets/$sheetUrl/values/$sheetName?key=$apiKey';
  static Future<List<Question>> getQuestionsFromAPI() async {
    final List<Question> questions = [];
    try{
      final res = await http.get(Uri.parse(url));
      if(res.statusCode != 200){
        throw 'Failed to load data.';
      }
      List<dynamic> rows = jsonDecode(res.body)['values'];
      for (var row in rows) {
        questions.add(Question(row[0], row[1], row[3], row[2], row[4], row[5] == 'A'));
      }
      if(questions.isEmpty) throw 'No questions in sheet';
    }catch(e){
      print(e);
    }
    return questions;
  }
}