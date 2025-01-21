import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import '../models/food.dart';
import '../providers/food_history_provider.dart';
import '../services/database_helper.dart';

class RandomPage extends StatefulWidget {
  const RandomPage({super.key});

  @override
  State<RandomPage> createState() => _RandomPageState();
}

class _RandomPageState extends State<RandomPage> {
  Food? currentFood;
  Food? lastFood;
  List<Food> foods = [];

  @override
  void initState() {
    super.initState();
    _loadFoods();
  }

  // DB에서 음식 목록 로드
  Future<void> _loadFoods() async {
    final loadedFoods = await DatabaseHelper.instance.getAllFoods();
    setState(() {
      foods = loadedFoods;
    });
    _getRandomFood();
  }

  void _getRandomFood() {
    if (foods.isEmpty) return;

    final random = Random();
    Food newFood;
    do {
      newFood = foods[random.nextInt(foods.length)];
    } while (newFood.name == lastFood?.name);

    setState(() {
      lastFood = currentFood;
      currentFood = newFood;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('오늘의 추천 메뉴'),
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            // color: Colors.red,
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (currentFood != null) ...[
                  Text(
                    currentFood!.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Image.asset(
                    currentFood!.imageUrl,
                    fit: BoxFit.cover,
                    height: 200,
                    width: 320,
                  ),
                ],
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: Icon(
                      Icons.autorenew,
                      color: Colors.white,
                    ),
                    onPressed: _getRandomFood,
                    label: Text(
                      '다른 메뉴 추천',
                      style: TextStyle(fontSize: 15),
                    ),
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        backgroundColor: Color(0xE6F28482),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: Icon(
                      Icons.bookmark_add,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      if (currentFood != null) {
                        context
                            .read<FoodHistoryProvider>()
                            .addFood(currentFood!.name);
                      }
                    },
                    label: Text('선택(기록)', style: TextStyle(fontSize: 15)),
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        backgroundColor: Color(0xE6F28482),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 5, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '내가 선택했던 메뉴 보기',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: Consumer<FoodHistoryProvider>(
                      builder: (context, provider, child) {
                        return ListView.builder(
                          itemCount: provider.selectedFoods.length,
                          itemBuilder: (context, index) {
                            final parts =
                                provider.selectedFoods[index].split(',');
                            final foodName = parts[0];
                            final dateTime = DateTime.parse(parts[1]);
                            return ListTile(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 0),
                              leading: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6), // 박스 내부 여백
                                decoration: BoxDecoration(
                                  color: Color(0xE6F28482), // 박스 배경색
                                  borderRadius:
                                      BorderRadius.circular(8), // 모서리 둥글게
                                ),
                                child: Text(
                                  '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}',
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.white),
                                ),
                              ),
                              title: Text(
                                foodName,
                                style: TextStyle(fontSize: 15),
                              ),
                              trailing: IconButton(
                                icon: Icon(
                                  Icons.close,
                                  color: Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Colors.black
                                      : Colors.white,
                                ),
                                onPressed: () {
                                  provider.removeFood(index);
                                },
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
