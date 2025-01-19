import '../models/food.dart';

final List<Food> initialFoods = [
  Food(
    name: '김치찌개',
    nameEng: 'Kimchi Stew',
    imageUrl: 'assets/images/foods/kimchi_stew.jpg',
    origin: '한국',
    tags: '찌개,매운음식,한식,국물요리',
    isVegan: false,
    popularity: 5,
    description:
        '김치를 주재료로 하는 한국의 대표적인 찌개 요리입니다. 묵은지를 사용하면 더욱 깊은 맛을 낼 수 있으며, 돼지고기, 참치, 꽁치 등 다양한 재료와 함께 조리할 수 있습니다.',
  ),
  Food(
    name: '치킨',
    nameEng: 'Korean Fried Chicken',
    imageUrl: 'assets/images/foods/chicken.jpg',
    origin: '한국',
    tags: '치킨,양념,후라이드,간식',
    isVegan: false,
    popularity: 5,
    description:
        '한국식 치킨은 바삭한 튀김옷과 특유의 양념으로 세계적으로 인정받는 요리입니다. 후라이드, 양념, 간장 등 다양한 맛으로 즐길 수 있습니다.',
  ),
  Food(
    name: '비빔밥',
    nameEng: 'Bibimbap',
    imageUrl: 'assets/images/foods/bibimbap.jpg',
    origin: '한국',
    tags: '밥,한식,매운음식,건강식',
    isVegan: true,
    popularity: 4,
    description:
        '다양한 나물과 고추장을 밥과 함께 비벼 먹는 한국의 전통 음식입니다. 영양이 풍부하고 건강에도 좋은 한국의 대표적인 건강식입니다.',
  ),
  Food(
    name: '피자',
    nameEng: 'Pizza',
    imageUrl: 'assets/images/foods/pizza.jpg',
    origin: '이탈리아',
    tags: '피자,치즈,패스트푸드,간식',
    isVegan: false,
    popularity: 5,
    description:
        '이탈리아에서 시작된 세계적인 음식으로, 얇은 도우 위에 토마토 소스와 치즈, 다양한 토핑을 올려 구운 요리입니다. 현대에는 각 나라의 특색을 반영한 다양한 피자가 있습니다.',
  ),
  Food(
    name: '햄버거',
    nameEng: 'Hamburger',
    imageUrl: 'assets/images/foods/hamburger.jpg',
    origin: '미국',
    tags: '패스트푸드',
    isVegan: false,
    popularity: 5,
    description: '미국에서 시작된 패스트푸드 음식입니다.',
  ),
  // ... 더 많은 음식 데이터 추가
];
