import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'dart:math';
import 'dart:async';

// MenuItem 클래스를 밖으로 이동
class MenuItem {
  final String name;
  final Color color;

  MenuItem(this.name, this.color);
}

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  List<MenuItem> menus = [];
  final TextEditingController _menuController = TextEditingController();
  final FocusNode _menuFocusNode = FocusNode();
  bool isSpinning = false;
  int selected = 0;
  late StreamController<int> controller;

  // 사용 가능한 색상 목록
  final List<Color> availableColors = [
    const Color(0xFFffadad),
    const Color(0xFFFFD6A5),
    const Color(0xFFFDFFB6),
    const Color(0xFFCAFFBF),
    const Color(0xFF9BF6FF),
    const Color(0xFFA0C4FF),
    const Color(0xFFBDB2FF),
    const Color(0xFFFFC6FF),
  ];

  // 이미 사용된 색상 목록
  final List<Color> usedColors = [];

  // 키보드 포커스 상태를 추적하기 위한 변수 추가
  bool isKeyboardFocused = false;

  @override
  void initState() {
    super.initState();
    controller = StreamController<int>.broadcast();

    // 포커스 노드에 리스너 추가
    _menuFocusNode.addListener(() {
      setState(() {
        isKeyboardFocused = _menuFocusNode.hasFocus;
      });
    });
  }

  Color getRandomColor() {
    // 모든 색상이 사용되었다면 초기화
    if (availableColors.isEmpty) {
      availableColors.addAll(usedColors);
      usedColors.clear();
    }

    // 남은 색상 중에서 랜덤하게 선택
    final randomIndex = Random().nextInt(availableColors.length);
    final selectedColor = availableColors[randomIndex];

    // 선택된 색상을 사용 가능 목록에서 제거하고 사용된 목록에 추가
    availableColors.removeAt(randomIndex);
    usedColors.add(selectedColor);

    return selectedColor;
  }

  void addMenu() {
    if (_menuController.text.isNotEmpty) {
      setState(() {
        menus.add(MenuItem(_menuController.text, getRandomColor()));
        _menuController.clear();
      });
      if (menus.length < 6) {
        FocusScope.of(context).requestFocus(_menuFocusNode);
      } else {
        FocusScope.of(context).unfocus();
      }
    }
  }

  void removeMenu(int index) {
    setState(() {
      // 삭제된 메뉴의 색상을 다시 사용 가능한 목록에 추가
      final removedColor = menus[index].color;
      availableColors.add(removedColor);
      usedColors.remove(removedColor);

      menus.removeAt(index);
    });
  }

  void resetMenus() {
    setState(() {
      menus.clear();
      isSpinning = false;
      controller.close();
      controller = StreamController<int>.broadcast();

      // 색상 목록도 초기화
      availableColors.addAll(usedColors);
      usedColors.clear();
    });
  }

  void spinWheel() {
    if (!isSpinning) {
      FocusScope.of(context).unfocus();
      setState(() {
        selected = Random().nextInt(menus.length);
        isSpinning = true;
        controller.add(selected);
      });
    }
  }

  void showResultDialog(String selectedMenu) {
    FocusScope.of(context).unfocus();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('결과'),
          content: Text('선택된 메뉴: $selectedMenu'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                FocusScope.of(context).unfocus();
              },
              child: const Text('확인'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('메뉴 선택'),
          elevation: 0,
        ),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                if (menus.length < 6)
                  TextField(
                    controller: _menuController,
                    focusNode: _menuFocusNode,
                    decoration: const InputDecoration(
                      hintText: '메뉴를 입력하세요',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 15,
                      ),
                    ),
                    onSubmitted: (_) => addMenu(),
                    textInputAction: TextInputAction.done,
                  ),
                const SizedBox(height: 16),
                if (menus.isNotEmpty) ...[
                  const Text(
                    '추가된 메뉴',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 10,
                    runSpacing: 4,
                    children: menus.asMap().entries.map((entry) {
                      final isDarkMode =
                          Theme.of(context).brightness == Brightness.dark;
                      return Chip(
                        label: Text(entry.value.name),
                        deleteIcon: Icon(
                          Icons.close,
                          color: isDarkMode ? Colors.white70 : Colors.black54,
                        ),
                        onDeleted: () => removeMenu(entry.key),
                        backgroundColor: entry.value.color,
                        labelStyle: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        deleteIconColor:
                            isDarkMode ? Colors.white70 : Colors.black54,
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 14),
                ],
                Expanded(
                  child: menus.length >= 2
                      ? FortuneWheel(
                          selected: controller.stream,
                          animateFirst: false,
                          physics: CircularPanPhysics(
                            duration: const Duration(seconds: 1),
                            curve: Curves.decelerate,
                          ),
                          onFling: () {
                            spinWheel();
                          },
                          items: List<FortuneItem>.from(
                            menus.map((menu) => FortuneItem(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      menu.name,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  style: FortuneItemStyle(
                                    color: menu.color,
                                    borderColor: Colors.white,
                                    borderWidth: 2,
                                  ),
                                )),
                          ),
                          indicators: isKeyboardFocused
                              ? const [] // 키보드가 활성화되면 indicators 비활성화
                              : [
                                  FortuneIndicator(
                                    alignment: Alignment.topCenter,
                                    child: TriangleIndicator(
                                      color: Color(0xE6588157),
                                    ),
                                  ),
                                ],
                          onAnimationEnd: () {
                            setState(() {
                              isSpinning = false;
                            });
                            showResultDialog(menus[selected].name);
                          },
                        )
                      : const Center(
                          child: Text(
                            '메뉴를 2개 이상 추가해주세요\n\n(최대 6개)',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16, bottom: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: menus.isNotEmpty ? resetMenus : null,
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xE6588157),
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          child: const Text('초기화'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: (menus.length >= 2 && !isSpinning)
                              ? spinWheel
                              : null,
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xE6588157),
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          child: const Text('룰렛 돌리기'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _menuController.dispose();
    controller.close();
    _menuFocusNode.dispose();
    super.dispose();
  }
}
