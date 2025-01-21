import 'package:flutter/material.dart';

class CategoryColor {
  static const Map<String, Color> colors = {
    '한식': Color(0xE6FFF1E6), // 연한 빨강
    '중식': Color(0xE6FFD6A5), // 주황
    '일식': Color(0xE6FFC6FF), // 연한 초록
    '양식': Color(0xE6A0C4FF), // 하늘색
    '퓨전': Color(0xE6CAFFBF), // 보라
    '패스트푸드': Color(0xE6FFADAD), // 노랑
    '디저트': Color(0xE6FDFFB6), // 분홍
    '분식': Color(0xE69BF6FF), // 밝은 파랑
  };

  static Color getColor(String category) {
    return colors[category] ?? Colors.grey; // 카테고리가 없을 경우 회색 반환
  }

  static Color getTextColor(String category) {
    // 배경색이 밝은 경우 어두운 텍스트, 어두운 경우 밝은 텍스트
    final color = colors[category] ?? Colors.grey;
    return color.computeLuminance() > 0.5 ? Colors.black87 : Colors.white;
  }
}
