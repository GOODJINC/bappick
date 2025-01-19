import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/food.dart';
import '../data/initial_foods.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('foods.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 4,
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE foods(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        nameEng TEXT NOT NULL,
        imageUrl TEXT NOT NULL,
        category TEXT NOT NULL,
        tags TEXT NOT NULL,
        isVegan INTEGER NOT NULL,
        popularity INTEGER NOT NULL,
        description TEXT NOT NULL
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute(
          'ALTER TABLE foods ADD COLUMN nameEng TEXT NOT NULL DEFAULT ""');
    }
    if (oldVersion < 3) {
      await db.execute(
          'ALTER TABLE foods ADD COLUMN description TEXT NOT NULL DEFAULT ""');
    }
    if (oldVersion < 4) {
      await db.execute(
          'ALTER TABLE foods ADD COLUMN category TEXT NOT NULL DEFAULT ""');
      try {
        await db.execute('UPDATE foods SET category = origin');
        await db.execute('ALTER TABLE foods DROP COLUMN origin');
      } catch (e) {
        // origin 컬럼이 없는 경우 무시
      }
    }
  }

  // 음식 추가
  Future<int> insertFood(Food food) async {
    final db = await database;
    return await db.insert('foods', food.toMap());
  }

  // 모든 음식 조회
  Future<List<Food>> getAllFoods() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('foods');
    return List.generate(maps.length, (i) => Food.fromMap(maps[i]));
  }

  // 영어 이름으로 검색
  Future<List<Food>> searchFoodsByEngName(String query) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'foods',
      where: 'nameEng LIKE ?',
      whereArgs: ['%$query%'],
    );
    return List.generate(maps.length, (i) => Food.fromMap(maps[i]));
  }

  // 한글 또는 영어 이름으로 검색
  Future<List<Food>> searchFoodsByAnyName(String query) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'foods',
      where: 'name LIKE ? OR nameEng LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
    );
    return List.generate(maps.length, (i) => Food.fromMap(maps[i]));
  }

  // 태그로 검색
  Future<List<Food>> searchFoodsByTag(String tag) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'foods',
      where: 'tags LIKE ?',
      whereArgs: ['%$tag%'],
    );
    return List.generate(maps.length, (i) => Food.fromMap(maps[i]));
  }

  // 기원(나라/지역)으로 필터링
  Future<List<Food>> filterByOrigin(String origin) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'foods',
      where: 'origin = ?',
      whereArgs: [origin],
    );
    return List.generate(maps.length, (i) => Food.fromMap(maps[i]));
  }

  // 비건 음식만 필터링
  Future<List<Food>> getVeganFoods() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'foods',
      where: 'isVegan = ?',
      whereArgs: [1],
    );
    return List.generate(maps.length, (i) => Food.fromMap(maps[i]));
  }

  // 인기도순으로 정렬
  Future<List<Food>> getFoodsByPopularity() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'foods',
      orderBy: 'popularity DESC',
    );
    return List.generate(maps.length, (i) => Food.fromMap(maps[i]));
  }

  // 음식 정보 업데이트
  Future<int> updateFood(Food food) async {
    final db = await database;
    return await db.update(
      'foods',
      food.toMap(),
      where: 'id = ?',
      whereArgs: [food.id],
    );
  }

  // 음식 삭제
  Future<int> deleteFood(int id) async {
    final db = await database;
    return await db.delete(
      'foods',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // DB 닫기
  Future close() async {
    final db = await database;
    db.close();
  }

  // DB 초기화 함수
  Future<void> initializeDatabase() async {
    final db = await database;

    // 테이블이 비어있는지 확인
    final count =
        Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM foods'));

    // 테이블이 비어있을 때만 초기 데이터 삽입
    if (count == 0) {
      for (var food in initialFoods) {
        await insertFood(food);
      }
    }
  }

  // 테이블 초기화 (모든 데이터 삭제 후 다시 초기 데이터 삽입)
  Future<void> resetDatabase() async {
    final db = await database;
    await db.delete('foods');
    for (var food in initialFoods) {
      await insertFood(food);
    }
  }

  // 카테고리로 필터링하는 메소드 추가
  Future<List<Food>> filterByCategory(String category) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'foods',
      where: 'category = ?',
      whereArgs: [category],
    );
    return List.generate(maps.length, (i) => Food.fromMap(maps[i]));
  }

  // 카테고리 목록 가져오기
  Future<List<String>> getAllCategories() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'foods',
      columns: ['DISTINCT category'],
      orderBy: 'category ASC',
    );
    return maps.map((map) => map['category'] as String).toList();
  }
}
