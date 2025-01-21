import 'package:flutter/material.dart';
import '../models/food.dart';
import '../utils/category_color.dart';

class FoodDetailDialog extends StatelessWidget {
  final Food food;

  const FoodDetailDialog({
    super.key,
    required this.food,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 이미지 (에러 처리 추가)
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.asset(
              food.imageUrl,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                // 이미지 로드 실패시 기본 이미지 표시
                return Container(
                  width: double.infinity,
                  height: 200,
                  color: Colors.grey[300],
                  child: const Icon(
                    Icons.restaurant,
                    size: 64,
                    color: Colors.grey,
                  ),
                );
              },
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
                            fontSize: 14,
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
                        color: CategoryColor.getColor(food.category),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        food.category,
                        style: TextStyle(
                          color: CategoryColor.getTextColor(food.category),
                          fontWeight: FontWeight.bold,
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

                // 인기도
                Row(
                  children: [
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
    );
  }
}
