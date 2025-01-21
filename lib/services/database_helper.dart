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
      version: 1,
      onCreate: _createDB,
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
        popularity INTEGER NOT NULL,
        description TEXT NOT NULL
      )
    ''');
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

    // 디버깅을 위한 로그 추가
    print('Retrieved ${maps.length} foods from database');
    if (maps.isNotEmpty) {
      print('Sample food: ${maps.first}');
    }

    return List.generate(maps.length, (i) {
      try {
        return Food.fromMap(maps[i]);
      } catch (e) {
        print('Error converting food at index $i: $e');
        print('Data: ${maps[i]}');
        rethrow;
      }
    });
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
    try {
      final db = await database;
      final count = Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM foods'));

      print('Current food count in DB: $count');

      if (count == 0) {
        print('Initializing database with ${initialFoods.length} foods');

        await db.transaction((txn) async {
          for (var food in initialFoods) {
            await txn.insert('foods', food.toMap());
          }
        });

        final newCount = Sqflite.firstIntValue(
            await db.rawQuery('SELECT COUNT(*) FROM foods'));
        print('After initialization, food count: $newCount');
      }
    } catch (e) {
      print('Error initializing database: $e');
    }
  }

  // 데이터베이스 리셋 메서드 추가
  Future<void> resetDatabase() async {
    try {
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, 'foods.db');

      // 기존 데이터베이스 파일 삭제
      await deleteDatabase(path);
      print('Existing database deleted');

      // 새로운 데이터베이스 초기화
      final db = await database;
      await initializeDatabase();
      print('Database reset and reinitialized with new data');
    } catch (e) {
      print('Error resetting database: $e');
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

  // 데이터베이스 상태 확인을 위한 메서드 추가
  Future<void> checkDatabaseState() async {
    final db = await database;
    final tables = await db
        .query('sqlite_master', where: 'type = ?', whereArgs: ['table']);
    print('Tables in database: ${tables.map((t) => t['name'])}');

    final foodCount =
        Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM foods'));
    print('Number of foods in database: $foodCount');

    if (foodCount == 0) {
      print('Database is empty. Initializing with default data...');
      await initializeDatabase();
    }
  }
}
