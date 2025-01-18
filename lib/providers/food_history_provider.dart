import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bappick/models/food.dart';
import 'dart:convert';

class FoodHistoryProvider with ChangeNotifier {
  List<String> _selectedFoods = [];

  List<String> get selectedFoods => _selectedFoods;

  FoodHistoryProvider() {
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    _selectedFoods = prefs.getStringList('food_history') ?? [];
    notifyListeners();
  }

  Future<void> addFood(String foodName) async {
    final prefs = await SharedPreferences.getInstance();
    _selectedFoods.insert(0, "${foodName},${DateTime.now().toString()}");
    await prefs.setStringList('food_history', _selectedFoods);
    notifyListeners();
  }

  Future<void> removeFood(int index) async {
    final prefs = await SharedPreferences.getInstance();
    _selectedFoods.removeAt(index);
    await prefs.setStringList('food_history', _selectedFoods);
    notifyListeners();
  }
}
