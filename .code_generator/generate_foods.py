import csv

# CSV 파일 경로 설정
csv_file_path = 'foods.csv'

# 결과 코드를 저장할 파일(선택 사항)
output_file_path = 'foods_output.txt'

# 출력 결과를 파일에 기록할지 여부
write_to_file = True

def convert_to_food_code(row):
    """
    CSV 한 줄(row)을 입력받아서
    Food(...) 형식의 문자열을 만들어 반환
    """
    name = row['name']
    nameEng = row['nameEng']
    imageUrl = row['imageUrl']
    category = row['category']
    tags = row['tags']
    popularity = row['popularity']
    description = row['description']

    # Food(...) 형태의 문자열 만들기
    # isVegan처럼 bool 처리가 필요한 경우 주의해서 변환
    # popularity는 int 처리가 필요하다면 int(...) 변환 가능
    code = (
        f"Food(\n"
        f"    name: '{name}',\n"
        f"    nameEng: '{nameEng}',\n"
        f"    imageUrl: '{imageUrl}',\n"
        f"    category: '{category}',\n"
        f"    tags: '{tags}',\n"
        f"    popularity: {popularity},\n"
        f"    description: '{description}',\n"
        f"),\n"
    )
    return code

if __name__ == "__main__":
    result_lines = []

    with open(csv_file_path, mode='r', encoding='utf-8') as f:
        reader = csv.DictReader(f)
        for row in reader:
            code_line = convert_to_food_code(row)
            result_lines.append(code_line)

    # 결과 출력
    final_code = ''.join(result_lines)
    print(final_code)

    # 파일에 저장하기(선택)
    if write_to_file:
        with open(output_file_path, mode='w', encoding='utf-8') as out_f:
            out_f.write(final_code)
        print(f"\n[INFO] 파일 '{output_file_path}' 로 변환된 코드를 저장했습니다.")
