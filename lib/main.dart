import 'dart:math';

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
  //9つのブロックの状態管理をするリスト
  List<PieaceStatus> statusList = List.filled(9, PieaceStatus.none);
  //ゲームの進行状態を管理する変数
  GameStatus gameStatus = GameStatus.play;
  //勝敗の表示用
  var buildLine = Container();
  //勝敗表示の線の太さ
  double lineThickness = 6.0;
  //幅
  double lineWidth = 0;
  
  //勝敗の判定
  //横の勝敗
  final List<List<int>> settlementListHorizontal = [
    [0, 1, 2],
    [3, 4, 5],
    [6, 7 ,8]
  ];
  //縦の勝敗
  final List<List<int>> settlementListVertical = [
    [0,3,6],
    [1,4,7],
    [2,5,8]
  ];
  //斜めの勝敗
  final List<List<int>> settlementListDiagonal = [
    [0, 4, 8],
    [2, 4, 6]
  ];


  @override
  Widget build(BuildContext context) {
    //MediaQuery.of(context).size.width は利用している端末の横幅いっぱいのサイズを取得する
    //contextを使うのでbuild内でしか使えない
    lineWidth = MediaQuery.of(context).size.width;
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
                buildtext(),
                //リセットボタン
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      // width: 2,
                    )
                  ),
                  onPressed: (){
                    setState(() {
                      turnOfCircle = true;
                      statusList = List.filled(9, PieaceStatus.none);
                      gameStatus = GameStatus.play;
                      buildLine = Container();
                      
                    });
                  },
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

  Widget buildtext() {
    switch(gameStatus){
      case GameStatus.play:
        return Row(
          children: [
            turnOfCircle 
            ? Icon(FontAwesomeIcons.circle)
            : Icon(Icons.clear),
            Text('のターンです'),
          ],
        );
        break;
      case GameStatus.draw:
        return Text('引き分け');
        break;
      case GameStatus.settlement:
        return Row(
          children: [
            !turnOfCircle 
            ? Icon(FontAwesomeIcons.circle)
            : Icon(Icons.clear),
            Text('の勝ちです'),
          ],
        );
      break;
      default:
        return Container();
      break;
    }
  }

  Stack buildField() {
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
              onTap: gameStatus == GameStatus.play ?(){
                if(statusList[_index] == PieaceStatus.none){
                  //タップされた際のステータスの変更
                  statusList[_index] = turnOfCircle ? PieaceStatus.circle : PieaceStatus.cross;
                  //turnOfCircleがtrueならfalseに。falseならtrueに変更。
                  turnOfCircle = !turnOfCircle;
                  confirmResult();
                };
                //buildメソッドをサイド実行する
                setState(() {} );
              } : null,

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

    return Stack(
      children: [
        Column(children: _columnChildren,),
        Stack(
          children: [
            buildLine,
          ],
        )
      ],
    );
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

  //勝敗を判定するメソッド
  void confirmResult(){
    //引き分け
    if(!statusList.contains(PieaceStatus.none)){
      gameStatus = GameStatus.draw;
    }
    //横の勝敗チェック
    for(int i = 0; i < settlementListHorizontal.length; i++){
      if(statusList[settlementListHorizontal[i][0]] == statusList[settlementListHorizontal[i][1]]
        && statusList[settlementListHorizontal[i][1]] == statusList[settlementListHorizontal[i][2]]
        && statusList[settlementListHorizontal[i][0]] != PieaceStatus.none){
          buildLine = (
            Container(
              width: lineWidth,
              height: lineThickness,
              color: Colors.black.withOpacity(0.4),
              margin: EdgeInsets.only(top: lineWidth / 3 * i + lineWidth / 6 - lineThickness / 2),
            )
          );
          gameStatus = GameStatus.settlement;
      }
    }
    //縦の勝敗チェック
    for(int i = 0; i < settlementListVertical.length; i++){
      if(statusList[settlementListVertical[i][0]] == statusList[settlementListVertical[i][1]]
        && statusList[settlementListVertical[i][1]] == statusList[settlementListVertical[i][2]]
        && statusList[settlementListVertical[i][0]] != PieaceStatus.none){
          buildLine = (
            Container(
              width: lineThickness,
              height: lineWidth,
              color: Colors.black.withOpacity(0.4),
              margin: EdgeInsets.only(left: lineWidth / 3 * i + lineWidth / 6 -lineThickness / 2),
            )
          );
          gameStatus = GameStatus.settlement;
      }
    }
    //斜めの勝敗チェック
    for(int i = 0; i < settlementListDiagonal.length; i++){
      if(statusList[settlementListDiagonal[i][0]] == statusList[settlementListDiagonal[i][1]]
        && statusList[settlementListDiagonal[i][1]] == statusList[settlementListDiagonal[i][2]]
        && statusList[settlementListDiagonal[i][0]] != PieaceStatus.none){
          buildLine = Container(
            child: (
              Transform.rotate(
                alignment: i == 0 ? Alignment.topLeft : Alignment.topRight,
                angle: i == 0 ? -pi / 4 : pi / 4,
                child: Container(
                  //太さ
                  width: lineThickness,
                  //長さ
                  height: lineWidth * sqrt(2),
                  color: Colors.black.withOpacity(0.4),
                  margin: EdgeInsets.only(left: i==0 ? 0.0 : lineWidth - lineThickness),

                ),
              )
            ),
          );
          gameStatus = GameStatus.settlement;
      }
    }

  }
}

//done todo アプリのタイトル変更
//done todo フィールドのUIを作成
//done todo フィールドのUI作成をメソッドを用いて簡潔に
//done todo ターンの表示とクリアボタンの作成
//done todo マス目をタップ可能にし、タップ時にターン切り替え
//done todo マス目タップでマルバツを表示
//done todo ゲームの勝敗のパターンを書き出す
//done todo ゲームの勝敗を判定可能に
//done todo リセットボタンタップでリスタート可能に