import 'package:bappick/pages/all_foods_page.dart';
import 'package:flutter/material.dart';
import 'package:bappick/pages/settings.dart';
import 'package:provider/provider.dart';
import 'package:bappick/providers/theme_provider.dart';
import 'package:bappick/theme/app_theme.dart';
import 'package:bappick/pages/random_page.dart';
import 'package:bappick/providers/food_history_provider.dart';
import 'package:bappick/pages/game.dart';
import 'package:bappick/services/database_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.instance.initializeDatabase();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => FoodHistoryProvider()),
      ],
      child: const BapPickApp(),
    ),
  );
}

class BapPickApp extends StatelessWidget {
  const BapPickApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: '밥픽',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode:
              themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: const MainPage(),
        );
      },
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
        actions: [
          // 설정 버튼
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: Center(
              child: const Text(
                '오늘 뭐먹지?',
                style: TextStyle(
                  fontSize: 28,
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RandomPage()),
                    );
                  }, Color(0xE6F28482)),
                  _buildButton('월드컵', () {
                    print("월드컵 클릭");
                  }, Color(0xE6F6BD60)),
                  _buildButton('모든 메뉴 보기', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AllFoodsPage()),
                    );
                  }, Color(0xE600b4d8)),
                  _buildButton('게임', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => GamePage()),
                    );
                  }, Color(0xE6588157)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 버튼 위젯 생성 함수
  Widget _buildButton(
      String text, VoidCallback onPressed, Color backgroundColor) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
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
