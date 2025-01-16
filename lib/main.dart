import 'package:flutter/material.dart';

void main() {
  runApp(const BapPickApp());
}

class BapPickApp extends StatelessWidget {
  const BapPickApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '밥픽',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          // 설정 버튼
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              print("설정 버튼 클릭");
            },
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: Center(
              child: const Text(
                '오늘 뭐먹지?',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: GridView.count(
                crossAxisCount: 2, // 2개의 열
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                children: [
                  _buildButton('랜덤 추천', () {
                    print("랜덤 추천 클릭");
                  }),
                  _buildButton('월드컵', () {
                    print("월드컵 클릭");
                  }),
                  _buildButton('모든 메뉴 보기', () {
                    print("모든 메뉴 보기 클릭");
                  }),
                  _buildButton('게임', () {
                    print("게임 클릭");
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 버튼 위젯 생성 함수
  Widget _buildButton(String text, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.lightBlue,
        padding: const EdgeInsets.symmetric(vertical: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16, color: Colors.white),
      ),
    );
  }
}
