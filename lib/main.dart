import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TicTacToe',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(
              FontAwesomeIcons.rocket,
              color: Colors.lightGreen,
            ),
            SizedBox(
              width: 8,
            ),
            Text(
              'TicTacToe',
              style: TextStyle(
                fontSize: 24,
              ),
            ),
          ],
        ),
      ),
      body: buildField(),
    );
  }

  Column buildField() {
    //縦の３列を作成するためのリスト
    List<Widget> _columnChildren = [];
    //横の3列を作成するためのリスト
    List<Widget> _rowChildren = [];

    for(int h = 0; h < 3; h++){
    //横の行を作成するループ文
      for(int i = 0; i < 3; i++){
        _rowChildren.add(
          Expanded(
            child: AspectRatio(
              aspectRatio: 1.0,
              //条件分岐 i==2の時は ? 以下を実行 それ以外の時は : 以下を実行
              child: i == 2
                ? Row(
                  children: [
                    Container(
                      child: Text(
                        '${i}',
                        style: TextStyle(fontSize: 24, color: Colors.red),
                      ),
                    ),
                  ],
                )
                : Row(
                children: [
                  Expanded(
                    child: Container(
                      child: Text(
                        '${i}',
                        style: TextStyle(fontSize: 24),

                      ),
                    ),
                  ),
                  VerticalDivider(width: 0.0,color: Colors.black,),
                ],
              ),
            ),
          ),
        );
      }
      _columnChildren.add(Row(children: _rowChildren,));
      _columnChildren.add(Divider(height:0.0, color: Colors.black,));
      _rowChildren = [];
    }

    return Column(children: _columnChildren,);
  }
}

//done todo アプリのタイトル変更
//done todo フィールドのUIを作成
//done todo フィールドのUI作成をメソッドを用いて簡潔に
//todo ターンの表示とクリアボタンの作成
//todo マス目をタップ可能にし、タップ時にターン切り替え
//todo マス目タップでマルバツを表示
//todo ゲームの勝敗のパターンを書き出す
//todo ゲームの勝敗を判定可能に
//todo リセットボタンタップでリスタート可能に