import 'package:flutter/material.dart';
import '../models/food.dart';
import '../services/database_helper.dart';
import '../utils/korean_search_helper.dart';
import '../widgets/food_detail_dialog.dart';
import '../utils/category_color.dart';

class AllFoodsPage extends StatefulWidget {
  const AllFoodsPage({super.key});

  @override
  State<AllFoodsPage> createState() => _AllFoodsPageState();
}

class _AllFoodsPageState extends State<AllFoodsPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Food> _allFoods = [];
  List<Food> _filteredFoods = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFoods();
    _searchController.addListener(_onSearchChanged);
  }

  Future<void> _loadFoods() async {
    try {
      await DatabaseHelper.instance.checkDatabaseState(); // 데이터베이스 상태 확인
      final foods = await DatabaseHelper.instance.getAllFoods();
      print('Loaded ${foods.length} foods from database');

      setState(() {
        _allFoods = foods;
        _filteredFoods = foods;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading foods: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    if (query.isEmpty) {
      setState(() => _filteredFoods = _allFoods);
      return;
    }

    setState(() {
      _filteredFoods = _allFoods.where((food) {
        // 일반 텍스트 검색
        final nameMatch = food.name.toLowerCase().contains(query);

        // 초성 검색 (우리가 만든 유틸리티 사용)
        final initialMatch = KoreanSearchHelper.matchInitials(food.name, query);

        // 영어 이름 검색
        final engNameMatch = food.nameEng.toLowerCase().contains(query);

        // 태그 검색
        final tagMatch =
            food.tagList.any((tag) => tag.toLowerCase().contains(query));

        // 카테고리 검색
        final categoryMatch = food.category.toLowerCase().contains(query);

        return nameMatch ||
            initialMatch ||
            engNameMatch ||
            tagMatch ||
            categoryMatch;
      }).toList();
    });
  }

  void _showFoodDetail(Food food) {
    FocusScope.of(context).unfocus();
    showDialog(
      context: context,
      builder: (context) => GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: FoodDetailDialog(food: food),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('모든 메뉴'),
          elevation: 0,
        ),
        body: Column(
          children: [
            // 검색창
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                autofocus: false,
                decoration: InputDecoration(
                  hintText: '음식 이름, 태그, 분류로 검색',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            FocusScope.of(context).unfocus();
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onSubmitted: (_) {
                  FocusScope.of(context).unfocus();
                },
              ),
            ),

            // 음식 리스트
            Expanded(
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        itemCount: _filteredFoods.length,
                        itemBuilder: (context, index) {
                          final food = _filteredFoods[index];
                          return Card(
                            // color: Color(0xE600b4d8),
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            child: ListTile(
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(
                                  food.imageUrl,
                                  width: 56,
                                  height: 56,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: 56,
                                      height: 56,
                                      color: Colors.grey[300],
                                      child: const Icon(
                                        Icons.restaurant,
                                        color: Colors.grey,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              onTap: () {
                                FocusScope.of(context).unfocus();
                                _showFoodDetail(food);
                              },
                              title: Text(
                                food.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(food.nameEng,
                                      style: const TextStyle(fontSize: 12)),
                                  const SizedBox(height: 4),
                                  Text(
                                    '#${food.tagList.join(' #')}',
                                    style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                              trailing: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: CategoryColor.getColor(food.category),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  food.category,
                                  style: TextStyle(
                                    color: CategoryColor.getTextColor(
                                        food.category),
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
