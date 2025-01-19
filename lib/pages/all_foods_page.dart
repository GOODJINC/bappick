import 'package:flutter/material.dart';
import '../models/food.dart';
import '../services/database_helper.dart';
import '../utils/korean_search_helper.dart';

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
    final foods = await DatabaseHelper.instance.getAllFoods();
    setState(() {
      _allFoods = foods;
      _filteredFoods = foods;
      _isLoading = false;
    });
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
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 이미지
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.asset(
                  food.imageUrl,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 이름
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              food.name,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              food.nameEng,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            food.category,
                            style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // 태그
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: food.tagList.map((tag) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .primaryContainer
                                .withOpacity(0.5),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text('#$tag'),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),

                    // 설명
                    Text(
                      food.description,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 16),

                    // 추가 정보
                    Row(
                      children: [
                        Icon(
                          Icons.eco,
                          color: food.isVegan
                              ? Colors.green
                              : Colors.grey.withOpacity(0.5),
                        ),
                        const SizedBox(width: 8),
                        Text(food.isVegan ? '비건 가능' : '비건 불가'),
                        const Spacer(),
                        ...List.generate(
                          5,
                          (index) => Icon(
                            Icons.star,
                            color: index < food.popularity
                                ? Colors.amber
                                : Colors.grey.withOpacity(0.3),
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
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
                    borderRadius: BorderRadius.circular(30),
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
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            child: ListTile(
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
                                  Text(food.nameEng),
                                  const SizedBox(height: 4),
                                  Text(
                                    '#${food.tagList.join(' #')}',
                                    style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      fontSize: 12,
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
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  food.category,
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer,
                                    fontSize: 12,
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
