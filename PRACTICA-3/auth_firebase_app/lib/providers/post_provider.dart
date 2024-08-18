import 'dart:convert';
import 'package:auth_firebase_app/models/post_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

final postsProvider = FutureProvider<List<Post>>((ref) async {
  final response =
      await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));
  final List<dynamic> data = json.decode(response.body);
  return data.map((json) => Post.fromJson(json)).toList();
});