import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tix_tac_toe/model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
  //ターンの判断に利用する変数 フラグ管理
  bool turnOfCircle = true;
  List<PieaceStatus> statusList = List.filled(9, PieaceStatus.none);

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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: 
              [
                Row(
                  children: [
                    turnOfCircle 
                    ? Icon(FontAwesomeIcons.circle)
                    : Icon(Icons.clear),
                    Text('のターンです'),
                  ],
                ),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      // width: 2,
                    )
                  ),
                  onPressed: (){},
                  child: Text('クリア'),
                )
              ],
            ),
          ),
          buildField(),
        ],
      ),
    );
  }

  Column buildField() {
    //縦の３列を作成するためのリスト
    List<Widget> _columnChildren = [Divider(height: 0.0, color: Colors.black,)];
    //横の3列を作成するためのリスト
    List<Widget> _rowChildren = [];

    //縦の列を作成するメソッド
    for(int h = 0; h < 3; h++){
    //横の行を作成するメソッド
      for(int i = 0; i < 3; i++){
        int _index = h * 3 + i;
        _rowChildren.add(
          Expanded(
            child: InkWell(
              onTap: (){
                if(statusList[_index] == PieaceStatus.none){
                  //タップされた際のステータスの変更
                  statusList[_index] = turnOfCircle ? PieaceStatus.circle : PieaceStatus.cross;
                  //turnOfCircleがtrueならfalseに。falseならtrueに変更。
                  turnOfCircle = !turnOfCircle;
                };

                //buildメソッドをサイド実行する
                setState(() {

                });
              },
              child: AspectRatio(
                aspectRatio: 1.0,
                //条件分岐 i==2の時は ? 以下を実行 それ以外の時は : 以下を実行
                child: Row(
                  children: [
                    Expanded(
                      child: buildContainer(statusList[_index]),
                    ),
                    (i == 2) ? Container() : VerticalDivider(color: Colors.black, width: 0.0,),
                  ],
                ),
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

  Container buildContainer(PieaceStatus pieaceStatus) {
    switch(pieaceStatus){
      case PieaceStatus.none:
        return Container();
        break;
      case PieaceStatus.circle:
        return Container(
          child: Icon(FontAwesomeIcons.circle, size: 60,color: Colors.blue,),
        );
        break;
      case PieaceStatus.cross:
        return Container(
          child: Icon(Icons.clear, size: 60, color: Colors.red,),
        );
        break;
      default:
      return Container();

    }
    return Container(
      child: Icon(FontAwesomeIcons.circle, size: 60,),
    );
  }
}

//done todo アプリのタイトル変更
//done todo フィールドのUIを作成
//done todo フィールドのUI作成をメソッドを用いて簡潔に
//done todo ターンの表示とクリアボタンの作成
//done todo マス目をタップ可能にし、タップ時にターン切り替え
//todo done マス目タップでマルバツを表示
//todo ゲームの勝敗のパターンを書き出す
//todo ゲームの勝敗を判定可能に
//todo リセットボタンタップでリスタート可能に