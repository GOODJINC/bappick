class Food {
  final int? id; // null 가능 (DB에 저장 시 자동 생성)
  final String name;
  final String nameEng; // 영어 이름 추가
  final String imageUrl;
  final String category; // origin 대신 category로 변경
  final String tags; // 쉼표로 구분된 태그들
  final bool isVegan;
  final int popularity; // 1-5 등급
  final String description; // 설명 필드 추가

  Food({
    this.id,
    required this.name,
    required this.nameEng, // 영어 이름 필드 추가
    required this.imageUrl,
    required this.category, // category로 변경
    required this.tags,
    required this.isVegan,
    required this.popularity,
    required this.description, // 설명 필드 추가
  });

  // tags 문자열을 List<String>으로 변환하는 getter 추가
  List<String> get tagList => tags.split(',');

  // Map으로 변환 (DB 저장용)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'nameEng': nameEng, // 영어 이름 매핑 추가
      'imageUrl': imageUrl,
      'category': category, // category로 변경
      'tags': tags,
      'isVegan': isVegan ? 1 : 0, // SQLite는 boolean을 지원하지 않아서 int로 변환
      'popularity': popularity,
      'description': description, // 설명 필드 매핑
    };
  }

  // Map에서 객체로 변환 (DB 조회용)
  factory Food.fromMap(Map<String, dynamic> map) {
    return Food(
      id: map['id'],
      name: map['name'],
      nameEng: map['nameEng'], // 영어 이름 매핑 추가
      imageUrl: map['imageUrl'],
      category: map['category'], // category로 변경
      tags: map['tags'],
      isVegan: map['isVegan'] == 1,
      popularity: map['popularity'],
      description: map['description'], // 설명 필드 매핑
    );
  }
}
