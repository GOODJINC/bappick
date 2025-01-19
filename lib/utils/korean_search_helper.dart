class KoreanSearchHelper {
  // 초성 리스트
  static const List<String> _initials = [
    'ㄱ',
    'ㄲ',
    'ㄴ',
    'ㄷ',
    'ㄸ',
    'ㄹ',
    'ㅁ',
    'ㅂ',
    'ㅃ',
    'ㅅ',
    'ㅆ',
    'ㅇ',
    'ㅈ',
    'ㅉ',
    'ㅊ',
    'ㅋ',
    'ㅌ',
    'ㅍ',
    'ㅎ'
  ];

  // 한글 유니코드 시작 값
  static const int _hanBegin = 0xAC00;
  // 한글 유니코드 끝 값
  static const int _hanEnd = 0xD7A3;
  // 한글 초성 유니코드 시작 값
  static const int _initialBegin = 0x1100;

  // 문자열에서 초성 추출
  static String getInitials(String text) {
    StringBuffer result = StringBuffer();

    for (int i = 0; i < text.length; i++) {
      int code = text.codeUnitAt(i);

      // 한글 범위 내인지 확인
      if (code >= _hanBegin && code <= _hanEnd) {
        // 초성 추출
        int initialIndex = ((code - _hanBegin) ~/ 28 ~/ 21);
        result.write(_initials[initialIndex]);
      } else {
        // 한글이 아닌 경우 그대로 추가
        result.write(text[i]);
      }
    }

    return result.toString();
  }

  // 초성 검색 매칭 확인
  static bool matchInitials(String text, String query) {
    // 검색어가 초성만으로 이루어져 있는지 확인
    bool isInitialSearch =
        query.split('').every((char) => _initials.contains(char));

    if (isInitialSearch) {
      String textInitials = getInitials(text);
      return textInitials.contains(query);
    }

    return false;
  }
}
