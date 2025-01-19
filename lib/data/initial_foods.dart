import '../models/food.dart';

// 카테고리 상수 정의 (타입 안정성을 위해)
class FoodCategory {
  static const String korean = '한식';
  static const String chinese = '중식';
  static const String japanese = '일식';
  static const String western = '양식';
  static const String fusion = '퓨전';
  static const String fastFood = '패스트푸드';
  static const String dessert = '디저트';
  static const String snack = '분식';
}

final List<Food> initialFoods = [
  Food(
    name: '김치찌개',
    nameEng: 'Kimchi Stew',
    imageUrl: 'assets/images/foods/kimchi_stew.jpg',
    category: FoodCategory.korean, // 카테고리로 변경
    tags: '찌개,매운음식,국물요리',
    isVegan: false,
    popularity: 5,
    description:
        '김치를 주재료로 하는 한국의 대표적인 찌개 요리입니다. 묵은지를 사용하면 더욱 깊은 맛을 낼 수 있으며, 돼지고기, 참치, 꽁치 등 다양한 재료와 함께 조리할 수 있습니다.',
  ),
  Food(
    name: '치킨',
    nameEng: 'Korean Fried Chicken',
    imageUrl: 'assets/images/foods/chicken.jpg',
    category: FoodCategory.korean,
    tags: '치킨,양념,후라이드,간식',
    isVegan: false,
    popularity: 5,
    description:
        '한국식 치킨은 바삭한 튀김옷과 특유의 양념으로 세계적으로 인정받는 요리입니다. 후라이드, 양념, 간장 등 다양한 맛으로 즐길 수 있습니다.',
  ),
  Food(
    name: '짜장면',
    nameEng: 'Jajangmyeon',
    imageUrl: 'assets/images/foods/jajangmyeon.jpg',
    category: FoodCategory.chinese,
    tags: '면요리,중식',
    isVegan: false,
    popularity: 5,
    description: '춘장과 다진 고기, 채소를 볶아 만든 소스를 면과 함께 비벼먹는 한국식 중화요리입니다.',
  ),
  Food(
    name: '초밥',
    nameEng: 'Sushi',
    imageUrl: 'assets/images/foods/sushi.jpg',
    category: FoodCategory.japanese,
    tags: '생선,해산물,일식',
    isVegan: false,
    popularity: 4,
    description: '신선한 생선이나 해산물을 초밥용 밥과 함께 먹는 일본의 대표적인 요리입니다.',
  ),
  Food(
    name: '피자',
    nameEng: 'Pizza',
    imageUrl: 'assets/images/foods/pizza.jpg',
    category: FoodCategory.western,
    tags: '피자,치즈,패스트푸드',
    isVegan: false,
    popularity: 5,
    description:
        '이탈리아에서 시작된 세계적인 음식으로, 얇은 도우 위에 토마토 소스와 치즈, 다양한 토핑을 올려 구운 요리입니다.',
  ),
  Food(
    name: '비빔밥',
    nameEng: 'Bibimbap',
    imageUrl: 'assets/images/foods/bibimbap.jpg',
    category: FoodCategory.korean,
    tags: '밥,한식,매운음식,건강식',
    isVegan: true,
    popularity: 4,
    description:
        '다양한 나물과 고추장을 밥과 함께 비벼 먹는 한국의 전통 음식입니다. 영양이 풍부하고 건강에도 좋은 한국의 대표적인 건강식입니다.',
  ),
  Food(
    name: '햄버거',
    nameEng: 'Hamburger',
    imageUrl: 'assets/images/foods/hamburger.jpg',
    category: FoodCategory.western,
    tags: '패스트푸드',
    isVegan: false,
    popularity: 5,
    description: '미국에서 시작된 패스트푸드 음식입니다.',
  ),
  // ... 더 많은 음식 데이터 추가
];
